//
//  ShowCamerautil.swift
//  GTEDai
//
//  Created by 国投 on 2018/5/30.
//  Copyright © 2018年 国投. All rights reserved.
//

import Foundation

@objcMembers
class ShowOpenCameraChaneImage: NSObject,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    weak var ctr:UIViewController!

    private var imageWidth:CGFloat = SCREEN_WIDTH
    private var imageHeight:CGFloat = SCREEN_HEIGHT

    var NEED_CUT:Bool = true
    var IS_MANY:Bool = false
    ///图片匡高比例
    var imageBili:CGFloat {
        get {
            return imageWidth/imageHeight
        }
        set {
            imageWidth = SCREEN_WIDTH
            imageHeight = SCREEN_WIDTH/(newValue)
        }
    }

    ///获取单张图片
    private var getImagecallback:((UIImage)->Void)?
    ///获取多张图片
    private var getImagescallback:(([UIImage])->Void)?

    var canclecallback:(()->Void)?

    ///是否现实头
    private  var allowsEditing = true

    ///允许重新计算宽高

    private  var picker:UIImagePickerController!

    private  lazy var alertUtils:AlertUtils = AlertUtils.init(ctr: ctr)

    private  var photoFact:TZPhotoFactory!

    ///实例化带裁剪的viwe
    class func newInstance(ctr:UIViewController,imageBili:CGFloat) -> ShowOpenCameraChaneImage {
        let instance = ShowOpenCameraChaneImage(ctr:ctr)
        instance.imageBili = imageBili
        return instance
    }

    ///普通初始化
    init(ctr:UIViewController) {
        super.init()
        self.ctr = ctr
        photoFact = TZPhotoFactory()

    }





    private func show(rect: CGRect? = nil) {
        alertUtils.showAlretSheet(title: "提示", message: nil, info: ["相机","相册","取消"], rect: rect, clickcomplete: { [weak self] index in
            if index == 0 {
                PermissionUtils.authorizeCameraWith(comletion: { [weak self] allow in
                    if allow {
                        self?.openCameara()
                    }else {
                        PermissionUtils.showRequestPermission(type: .CAMERA)
                    }
                })

            }else if index == 1 {
                PermissionUtils.authorizeCameraWith(comletion: { [weak self] allow in
                    if allow {
                        self?.openAlbum()
                    }else {
                        PermissionUtils.showRequestPermission(type: .ALBUM)
                    }
                })

            }
        })
    }


    //调用相机
    private func openCameara(){
        

        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //创建图片控制器
            picker = UIImagePickerController()
            //设置代理
            picker.delegate = self
            ///不明觉厉
            picker.modalPresentationStyle = .overCurrentContext
            //设置来源
            picker.sourceType = UIImagePickerController.SourceType.camera
            //允许编辑
            picker.allowsEditing = false
            //打开相机
            ctr.present(picker, animated: true, completion: { () -> Void in

            })
        }else{
            DEBUG.DEBUGPRINT(obj: "找不到相机")
        }

    }
    //打开相册
    private func openAlbum(){
        //判断设置是否支持图片库
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            if NEED_CUT {
                cropSelecImg()
            }else {
                noCropSelectimg()
            }
        }else{
            print("读取相册错误")
        }
    }

    //MARK: -----------------------------------------上传图片
    func showchangeImage(bili:CGFloat = SCREEN_WIDTH/SCREEN_HEIGHT,NEED_CUT:Bool = true,rect: CGRect? = nil,complete:((UIImage)->Void)?) {
        self.imageBili = bili
        self.NEED_CUT = NEED_CUT
        show(rect: rect)
        getImagecallback = { orgImg in
            complete?(orgImg)
        }
    }

    //MARK: -----------------------------------------duozhang图片
    func showmanyImage(rect: CGRect? = nil,complete:(([UIImage])->Void)?) {
        NEED_CUT = false
        IS_MANY = true
        show(rect: rect)
        getImagescallback = { images in
            complete?(images)
        }
    }

    func cropSelecImg() {
        photoFact.cropFromAlbum(ctr: ctr, imageWidth: imageWidth, imageHeight: imageHeight, didGetImage: {[weak self] (img) in
            self?.getImagecallback?(img)
        })
    }


    func noCropSelectimg() {
        if IS_MANY {

            photoFact.noCropFromAlbum(ctr: self.ctr, didGetImage: { [weak self] (images) in
                self?.getImagescallback?(images)

            })
        }else {
            photoFact.aloneFromAlbum(ctr: self.ctr, didGetImage: { [weak self] img in
                self?.didGetImage(img)
            })
        }

    }


    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {

        if NEED_CUT {
            photoFact.newinstanceFromCamera(ctr: picker, info: info, imageWidth: imageWidth, imageHeight: imageHeight, didGetImage: {[weak self] (img) in
                self?.getImagecallback?(img)
                self?.getImagescallback?([img])
                picker.navigationController?.dismiss(animated: true, completion: nil)
            })
        }else {

            photoFact.newinstanceFromCamera(ctr: picker, info: info, imageWidth: imageWidth, imageHeight: imageHeight, didGetImage: {[weak self] (img) in
                self?.getImagecallback?(img)
                self?.getImagescallback?([img])
                picker.navigationController?.dismiss(animated: true, completion: nil)
            })
        }
    }




    ///已经获取到图片
    private func didGetImage(_ image: UIImage) {
        //  CGRect.init(x: (self.size.width - CGFloat(subImageRef.width)) * 0.5, y: (self.size.height - CGFloat(subImageRef.height)) * 0.5, width: CGFloat(subImageRef.width), height: CGFloat(subImageRef.height))
        //let newimg = image.getSubImage(size: CGRect.init(x: 0, y: 0, width: imageWidth, height: imageHeight))
        //(newSize: CGSize.init(width: imageWidth, height: imageHeight))
        self.getImagecallback?(image)
    }

    deinit {
        DEBUG.DEBUGPRINT(obj: "释放了照片选择界面")
    }

}


///此方法是对第三方库进行封装不能直接调用
class TZPhotoFactory: NSObject,TZImagePickerControllerDelegate {

    var is_circle:Bool = false
    var radious:CGFloat = 0//倒角的角度


    ///从相册选图片--裁剪
    func cropFromAlbum(ctr:UIViewController,imageWidth:CGFloat,imageHeight:CGFloat,didGetImage:((UIImage)->Void)?) {

        let albumPicker:TZImagePickerController = TZImagePickerController.init(maxImagesCount: 1, columnNumber: 5, delegate: self , pushPhotoPickerVc: true)
        albumPicker.navigationBar.barTintColor = UIColor.red
        albumPicker.oKButtonTitleColorNormal = UIColor.black
        albumPicker.oKButtonTitleColorDisabled =  UIColor.blue
        albumPicker.allowTakePicture = false
        albumPicker.sortAscendingByModificationDate = false
        albumPicker.showSelectBtn = false
        albumPicker.allowCrop = true
        albumPicker.cropRect = CGRect(x:(ctr.view.frame.width - imageWidth) * 0.5,y:(ctr.view.frame.height - imageHeight) * 0.5,width:imageWidth,height:imageHeight)
        albumPicker.didFinishPickingPhotosHandle = {  (img,any,boo) in
            if let i = img {
                didGetImage?(i[0])
            }
        }
        ctr.present(albumPicker, animated: true, completion: nil)
    }

    ///从相册选图片--不裁剪,单选
    func aloneFromAlbum(ctr:UIViewController,didGetImage:((UIImage)->Void)?) {

        let albumPicker:TZImagePickerController = TZImagePickerController.init(maxImagesCount: 1, columnNumber: 5, delegate: self , pushPhotoPickerVc: true)
        albumPicker.navigationBar.barTintColor = 0xff4433.rgbColor
        albumPicker.oKButtonTitleColorNormal = UIColor.black
        albumPicker.oKButtonTitleColorDisabled =  UIColor.blue
        albumPicker.allowTakePicture = false
        albumPicker.sortAscendingByModificationDate = false
        albumPicker.showSelectBtn = false
        albumPicker.allowCrop = false
        albumPicker.didFinishPickingPhotosHandle = {  (img,any,boo) in
            if let i = img {
                didGetImage?(i[0])
            }
        }
        ctr.present(albumPicker, animated: true, completion: nil)
    }



    ///从相册选图片--不裁剪,多选
    func noCropFromAlbum(ctr:UIViewController,didGetImage:(([UIImage])->Void)?) {

        let albumPicker:TZImagePickerController = TZImagePickerController.init(maxImagesCount: 1, columnNumber: 5, delegate: self , pushPhotoPickerVc: true)
        albumPicker.navigationBar.barTintColor = 0xff4433.rgbColor
        albumPicker.oKButtonTitleColorNormal = UIColor.black
        albumPicker.oKButtonTitleColorDisabled =  UIColor.blue
        albumPicker.allowTakePicture = false
        albumPicker.sortAscendingByModificationDate = true
        //        albumPicker.showSelectBtn = true
        albumPicker.maxImagesCount = 16
        albumPicker.allowCrop = false
        //        albumPicker.allowPickingVideo = true
        ///如果isSelectOriginalPhoto为YES，表明用户选择了原图，[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
        albumPicker.didFinishPickingPhotosHandle = {  (img,assets,isSelectOriginalPhoto) in
            if let i = img {
                didGetImage?(i)
            }
        }
        ctr.present(albumPicker, animated: true, completion: nil)
    }


    ///从相机选图片----- 不能用
    func newinstanceFromCamera(ctr:UIViewController,info: [String : Any],imageWidth:CGFloat,imageHeight:CGFloat,didGetImage:((UIImage)->Void)?) {
        if let img:UIImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            let cutterViewController:PhotoCutterViewController = PhotoCutterViewController()
            cutterViewController.delegate = PhotoCutterViewControllerDelegate()
            if is_circle == true {
                cutterViewController.cutterType = CutterType.circle(radius: 0)
            }else{
                cutterViewController.cutterType = CutterType.rect(width: Float(imageWidth), height: Float(imageHeight))
            }

            cutterViewController.image = img.fixOrientation()
            cutterViewController.isFilter = false



            ctr.show(cutterViewController, sender: nil)

            cutterViewController.delegate?.didSuccesCutterPhoto = { (cutterView:PhotoCutterViewController , resultImage:UIImage?) in
                if let newimg = resultImage {
                    didGetImage?(newimg)
                }
            }
            cutterViewController.dismisscallback = {
                ctr.dismiss(animated: true, completion: nil)
            }

            if let nav = ctr as? UINavigationController {
                nav.navigationBar.isHidden = true
                nav.navigationBar.isOpaque = true
                nav.automaticallyAdjustsScrollViewInsets = false
                nav.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                nav.navigationBar.shadowImage = UIImage()
                nav.navigationBar.tintColor = UIColor.white
            }
        }
    }
}
