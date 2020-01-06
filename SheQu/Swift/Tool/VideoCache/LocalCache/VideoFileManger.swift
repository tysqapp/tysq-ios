//
//  VideoFileManger.swift
//  NetWorkDemo
//
//  Created by gm on 2018/6/15.
//  Copyright © 2018年 gm. All rights reserved.
//

import Foundation

#if DEBUG
fileprivate let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/video"
//fileprivate let documentPath = "/Users/gm/Desktop/MarkDown/video"
#else
fileprivate let documentPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first! + "/video"
#endif

typealias LocalUrlSCallBack = (_ urlSCallBack:NSArray)->()

private let fileMangerLock = NSLock.init()
private let cacheLock     = NSLock.init()
private let minFreeSize:Double       = 500 // 当设备内存少于这个值时，保留最后两个文件夹。如果还不够，将不再保存

class VideoFileManger: NSObject {
    
    var fileMangerQueque:OperationQueue?
    
    lazy var fileManager = FileManager.default
    
    static let shareInstance:VideoFileManger = {
        let instance = VideoFileManger.init()
        instance.fileMangerQueque = OperationQueue.init()
        instance.fileMangerQueque?.maxConcurrentOperationCount = 4
        return instance
    }()
    //缓存视频数据到本地
    open func saveVideoDataToLocal(_ saveFileData: NSData,_ folderName: String,_ fileName: String) {
        weak var weakSelf = self
        let  blockOperation = BlockOperation.init {
            cacheLock.lock()
            //TiercelLog("current Thread",Thread.current)
            let sysCache = weakSelf?.getSystemCache() ?? (0,0)
            if(sysCache.0 < minFreeSize){//当本地内存少于50mb时，删除文件夹
                let timeStr = documentPath + "/" + "time.plist"
                let timesM = NSMutableArray.init(contentsOfFile:timeStr)
                if((timesM?.count)! <= 2){//如果只有两个文件夹,后续将不再保存
                    cacheLock.unlock()
                    return
                }
                
                weakSelf?.deleteLocaclFolder(timesM!, timeStr)
            }
            let fileStr    = weakSelf?.combineTheFileDirectory(folderName, fileName) ?? ""
            
            if(weakSelf?.fileManager.fileExists(atPath: fileStr) ?? false){
                cacheLock.unlock()
                return
            }
            let saveSuccess = saveFileData.write(toFile: fileStr, atomically: true)
            if(saveSuccess){
                ////TiercelLog("保存成功")
            }
            cacheLock.unlock()
        }
        self.fileMangerQueque?.addOperation(blockOperation)
    }
    
    //根据plist文件获取最近的五个请求
    func getRequestsUrlFromLocal(_ num:NSInteger,_ folerName:String?,_ requestFile:String,_ fileType:String,_ callBack:@escaping LocalUrlSCallBack){
        if((folerName) == nil){
            callBack([])
            return;
        }
        let realFolderName    =  folerName!
        let realFileName      =  folerName!
        let localRequest      =  documentPath + "/" + realFolderName + "/" + realFileName + fileType
        let localRequestArray = NSArray.init(contentsOfFile: localRequest)
        if ((localRequestArray) == nil){
            callBack([])
            return
        }
        var index = -1
        
        for (num,subStr) in (localRequestArray?.enumerated())!{
            let subStrM:String = subStr as! String
            if(subStrM == requestFile){
                index = num
                break
            }
        }
        if(index < 0){
            callBack([])
            return
        }
        
        
        let difference         = (localRequestArray?.count)! - index
        
        if (difference >= num){
            callBack(localRequestArray?.subarray(with: NSMakeRange(index, num)) as! NSArray)
        }else{
            callBack(localRequestArray?.subarray(with: NSMakeRange(index, difference)) as! NSArray)
        }
        
    }
    

    
  //判断或创建文件夹目录
   func createPathForFolder(_ folderName: String) -> String {
    fileMangerLock.lock()//多线程加锁，保证创建文件夹线程安全
    let fileManger = FileManager.default
    let fullFolderName = documentPath + "/" + folderName
    if (!fileManger.fileExists(atPath:fullFolderName)) {
        do{
            try fileManger.createDirectory(atPath: fullFolderName, withIntermediateDirectories: true, attributes: nil)
        }
        catch{
            ////TiercelLog(error)
            fileMangerLock.unlock()
            return String.init()
        }
    }
        //time.plist 存放的是文件夹名字，按先后顺序
    let timeStr = documentPath + "/" + "time.plist"
        var foldersM = NSMutableArray.init(contentsOfFile:timeStr)
        if((foldersM) == nil){
            foldersM = NSMutableArray.init()
        }
    
    foldersM?.add(folderName)
        foldersM?.write(toFile: timeStr, atomically:true)
        fileMangerLock.unlock()
        return fullFolderName
    }
    
    //拼接文件路径 docu/文件夹(folder)/文件名(file)typeFile(eg .plist)
    func combineTheFileDirectory(_ folderPath:String,_ fileName:String)->String{
        if folderPath.hasPrefix("/var/mobile") {
            return folderPath + "/" + fileName
        }
        return documentPath + "/" + folderPath + "/" + fileName
    }
    
    open  func deleteDataFromLocalFolder(_ folderPath:String,_ fileName:String){
        
        let fullName    = combineTheFileDirectory(folderPath, fileName)
        if (fileManager.fileExists(atPath: fullName)) {
            do{
                try fileManager.removeItem(atPath: fullName)
            }
            catch{
            }
            
        }
    }
    
    //保存文件到本地
    @discardableResult
    open  func saveDataToLocalFolder(_ folderPath: String,_ fileName: String,_ saveData: Any) -> Bool{
        
        let fullFolderName = self.createPathForFolder(folderPath)
        
        if fullFolderName.count > 1 {
            
            let fullPath = fullFolderName + "/" + fileName
            let range = fileName.range(of: "plist")
            var isSave = false;
            
            if((range) != nil){
                
                let writeArray:NSArray = saveData as! NSArray
                isSave =  writeArray.write(toFile:fullPath, atomically: true)
                
            }else{
                
                if((fileName.range(of: ".txt")) != nil){
                    
                    let writeStr:String = saveData as! String
                    do{
                       try writeStr.write(toFile: fullPath, atomically:true, encoding: String.Encoding.utf8)
                    }catch{
                        
                    }
                    
                }else{
                    
                    let data:NSData = saveData as! NSData
                    isSave =  data.write(toFile: fullPath, atomically:true)
                    
                }
            }
            
            return isSave
        }
        
        return false
    }
    
    

    //获取本地缓存vedio文件
    open func getDataFromCache(_ folderName: String,_ fileName: String)-> NSData{
        
        let filePath = combineTheFileDirectory(folderName, fileName)
        do {
            return try NSData.init(contentsOfFile: filePath)
        } catch  {
            return NSData.init()
        }
        
    }
    
    func getSystemCache() -> (Double , Double){
        
        let manager = FileManager.default
        var freesize:Double = 0.0;
        var sysSize:Double  = 0.0;
        do
        {
            let home = NSHomeDirectory() as NSString
            let attribute = try manager.attributesOfFileSystem(forPath: home as String)
            freesize = attribute[FileAttributeKey.systemFreeSize]!as! Double
            sysSize  = attribute[FileAttributeKey.systemSize]!as! Double
            return (freesize/(1024 * 1024),sysSize/(1024 * 1024))
        }catch{
            return (-1,-1)
        }
    }
   
    func deleteCurrentFolder() {
        let timeStr = documentPath + "/" + "time.plist"
        let timesM = NSMutableArray.init(contentsOfFile:timeStr)
        if((timesM?.count)! <= 2){//如果只有两个文件夹,后续将不再保存
            return
        }
        
        deleteLocaclFolder(timesM!, timeStr)
    }
    
    
   func deleteLocaclFolder(_ foldersM:NSMutableArray,_ filePath:String){
    
        let blockOperation = BlockOperation.init {
            let folderLock = NSLock.init()
            folderLock.lock()
            let fileManager = FileManager.default
            let resultStrArray:NSArray = foldersM.subarray(with:NSMakeRange((foldersM.count-2),2)) as NSArray
            foldersM.removeObjects(in: NSMakeRange(foldersM.count-2,2))
            
            for folderName in foldersM {
                let folderNameTemp:String = folderName as! String
                let fullName = documentPath + "/" + folderNameTemp
                if(fileManager.fileExists(atPath: fullName)){
                    do{
                        try fileManager.removeItem(atPath: fullName)
                    }catch{
                        
                    }
                }
            }
            foldersM.removeAllObjects()
            resultStrArray.write(toFile: filePath, atomically: true)
            folderLock.unlock()
        }
    
     fileMangerQueque?.addOperation(blockOperation)
  }
        
        
}
