//
//  ContactsUtils.swift
//  VgSale
//
//  Created by ztsapp on 2017/8/23.
//  Copyright © 2017年 ztstech. All rights reserved.
//

import Foundation
import Contacts

///联系人utils
@objcMembers
class ContactsUtils: NSObject,CNContactPickerDelegate,ABPeoplePickerNavigationControllerDelegate,UINavigationControllerDelegate {

    private weak var ctr:UIViewController!

    var error:Unmanaged<CFError>?

    var addressBook:ABAddressBook!


    private lazy var alertUtils:AlertUtils = AlertUtils.init()

    private static var instance:ContactsUtils!

    @available(iOS 9.0, *)
    lazy var myContactStore: CNContactStore = {
        let cn:CNContactStore = CNContactStore()
        return cn
    }()

    var contactcallback:((ContacntBean?)->Void)?


    convenience init(vc:UIViewController) {

        self.init()
        self.ctr = vc
        alertUtils = AlertUtils.init(ctr: ctr)
        canReadContact {[weak self] (error) in
            if let _ = error {
                self?.goSeetingContact()
            }else {
                self?.initDelegate()
            }
        }
    }

    override init() {
        super.init()


    }


    private func initDelegate() {
        if #available(iOS 9.0, *) {

        }else {
        }
    }

    ///获取所有手机号不需要联系人界面
    func getcontacts(complete:(([ContacntBean]?)->Void)?){

        canReadContact(complete: {[weak self] (error) in
            if let _ = error {
                self?.goSeetingContact()
                complete?(nil)
            }else {
                if #available(iOS 9.0, *) {
                    self?.readContactsFromContactStore(self!.myContactStore, complete: complete)
                }else {
                    if let _ = self {
                        self?.addressBook = ABAddressBookCreateWithOptions(nil, &self!.error).takeRetainedValue()
                        self?.readRecord(complete: complete)
                    }
                }
            }
        })
    }


    func selectedcontactFromUI() {
        canReadContact(complete: {[weak self] (error) in
            if let _ = error {
                self?.goSeetingContact()
            }else {
                if #available(iOS 9.0, *) {
                    let picker = CNContactPickerViewController.init()
                    picker.delegate = self
                    self?.ctr.present(picker, animated: true, completion: nil)
                } else {
                    // Fallback on earlier versions //适配iOS9之前的联系人选择
                    let picker = ABPeoplePickerNavigationController.init()
                    picker.delegate = self
                    picker.peoplePickerDelegate = self
                    self?.ctr.present(picker, animated: true, completion: nil)
                }
            }
        })
    }

    ///取消获取联系人
    @available(iOS 9.0, *)
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        DEBUG.DEBUGPRINT(obj: "点击了取消选择联系人")
    }

    /*!
     * @abstract Singular delegate methods.
     * @discussion These delegate methods will be invoked when the user selects a single contact or property.
     */
    @available(iOS 9.0, *)
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact){
        let bean = ContacntBean()
        bean.contacntName = "\(contact.familyName)\(contact.givenName)"
        for item in contact.phoneNumbers {
            let num = item.value.stringValue
            let phone = (num as NSString).replacingOccurrences(of: "-", with: "")
            bean.contacntNum.append(phone)
        }
        if bean.contacntNum.count == 0 {
            bean.contacntNum.append("")
        }
        contactcallback?(bean)
    }

    ///单选进入详情代理方法
    //    @available(iOS 9.0, *)
    //    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
    //
    //    }


    ///多选代理方法
    //    @available(iOS 9.0, *)
    //    func contactPicker(_ picker: CNContactPickerViewController, didSelect contacts: [CNContact]) {
    //
    //    }
    //
    //    @available(iOS 9.0, *)
    //    func contactPicker(_ picker: CNContactPickerViewController, didSelectContactProperties contactProperties: [CNContactProperty]) {
    //
    //    }




    func peoplePickerNavigationControllerDidCancel(_ peoplePicker: ABPeoplePickerNavigationController) {
        DEBUG.DEBUGPRINT(obj: "点击了取消选择联系人")
    }



    func peoplePickerNavigationController(_ peoplePicker: ABPeoplePickerNavigationController, didSelectPerson person: ABRecord) {

        let bean = ContacntBean()

        let lastName = ABRecordCopyValue(person, kABPersonLastNameProperty)?
            .takeRetainedValue() as! String? ?? ""
        DEBUG.DEBUGPRINT(obj: "姓：\(lastName)")

        //获取名
        let firstName = ABRecordCopyValue(person, kABPersonFirstNameProperty)?
            .takeRetainedValue() as! String? ?? ""
        DEBUG.DEBUGPRINT(obj:"名：\(firstName)")

        bean.contacntName = "\(lastName)\(firstName)"

        //获取电话
        let phoneValues:ABMutableMultiValue? =
            ABRecordCopyValue(person, kABPersonPhoneProperty).takeRetainedValue()
        if phoneValues != nil {
            DEBUG.DEBUGPRINT(obj:"电话：")
            for i in 0 ..< ABMultiValueGetCount(phoneValues){

                // 获得标签名
                let phoneLabel = ABMultiValueCopyLabelAtIndex(phoneValues, i).takeRetainedValue()
                    as CFString;
                // 转为本地标签名（能看得懂的标签名，比如work、home）
                let localizedPhoneLabel = ABAddressBookCopyLocalizedLabel(phoneLabel)
                    .takeRetainedValue() as String

                let value = ABMultiValueCopyValueAtIndex(phoneValues, i)
                let phone = value?.takeRetainedValue() as! String
                let num = (phone as NSString).replacingOccurrences(of: "-", with: "")
                DEBUG.DEBUGPRINT(obj:"  \(localizedPhoneLabel):\(phone)")
                bean.contacntNum.append(num)
            }
        }

        if bean.contacntNum.count == 0 {
            bean.contacntNum.append("")
        }
        contactcallback?(bean)
    }





    @available(iOS 8.0,*)
    func readRecord(complete:(([ContacntBean])->Void)?) {

        var contacts:[ContacntBean] = []

            //获取并遍历所有联系人记录
        let sysContacts:NSArray = ABAddressBookCopyArrayOfAllPeople(addressBook)
                .takeRetainedValue() as NSArray
        for item in sysContacts {
            let bean = ContacntBean()

            let contact = item as ABRecord
            //获取姓
            let lastName = ABRecordCopyValue(contact, kABPersonLastNameProperty)?
                .takeRetainedValue() as! String? ?? ""
            DEBUG.DEBUGPRINT(obj: "姓：\(lastName)")

            //获取名
            let firstName = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?
                .takeRetainedValue() as! String? ?? ""
            DEBUG.DEBUGPRINT(obj:"名：\(firstName)")

            bean.contacntName = "\(lastName)\(firstName)"

            //昵称
            let nikeName = ABRecordCopyValue(contact, kABPersonNicknameProperty)?
                .takeRetainedValue() as! String? ?? ""
            DEBUG.DEBUGPRINT(obj:"昵称：\(nikeName)")

            //公司（组织）
            let organization = ABRecordCopyValue(contact, kABPersonOrganizationProperty)?
                .takeRetainedValue() as! String? ?? ""
            DEBUG.DEBUGPRINT(obj:"公司（组织）：\(organization)")

            //职位
            let jobTitle = ABRecordCopyValue(contact, kABPersonJobTitleProperty)?
                .takeRetainedValue() as! String? ?? ""
            DEBUG.DEBUGPRINT(obj:"职位：\(jobTitle)")

            //部门
            let department = ABRecordCopyValue(contact, kABPersonDepartmentProperty)?
                .takeRetainedValue() as! String? ?? ""
            DEBUG.DEBUGPRINT(obj:"部门：\(department)")

            //备注
            let note = ABRecordCopyValue(contact, kABPersonNoteProperty)?
                .takeRetainedValue() as! String? ?? ""
            DEBUG.DEBUGPRINT(obj:"备注：\(note)")

            //获取电话
            let phoneValues:ABMutableMultiValue? =
                ABRecordCopyValue(contact, kABPersonPhoneProperty).takeRetainedValue()
            if phoneValues != nil {
                DEBUG.DEBUGPRINT(obj:"电话：")
                for i in 0 ..< ABMultiValueGetCount(phoneValues){

                    // 获得标签名
                    let phoneLabel = ABMultiValueCopyLabelAtIndex(phoneValues, i).takeRetainedValue()
                        as CFString;
                    // 转为本地标签名（能看得懂的标签名，比如work、home）
                    let localizedPhoneLabel = ABAddressBookCopyLocalizedLabel(phoneLabel)
                        .takeRetainedValue() as String

                    let value = ABMultiValueCopyValueAtIndex(phoneValues, i)
                    let phone = value?.takeRetainedValue() as! String
                    DEBUG.DEBUGPRINT(obj:"  \(localizedPhoneLabel):\(phone)")
                    bean.contacntNum.append(phone)
                }
            }

            //获取Email
            let emailValues:ABMutableMultiValue? =
                ABRecordCopyValue(contact, kABPersonEmailProperty).takeRetainedValue()
            if emailValues != nil {
                DEBUG.DEBUGPRINT(obj:"Email：")
                for i in 0 ..< ABMultiValueGetCount(emailValues){

                    // 获得标签名
                    let label = ABMultiValueCopyLabelAtIndex(emailValues, i).takeRetainedValue()
                        as CFString;
                    let localizedLabel = ABAddressBookCopyLocalizedLabel(label)
                        .takeRetainedValue() as String

                    let value = ABMultiValueCopyValueAtIndex(emailValues, i)
                    let email = value?.takeRetainedValue() as! String
                    DEBUG.DEBUGPRINT(obj:"  \(localizedLabel):\(email)")
                }
            }

            //获取地址
            let addressValues:ABMutableMultiValue? =
                ABRecordCopyValue(contact, kABPersonAddressProperty).takeRetainedValue()
            if addressValues != nil {
                DEBUG.DEBUGPRINT(obj:"地址：")
                for i in 0 ..< ABMultiValueGetCount(addressValues){

                    // 获得标签名
                    let label = ABMultiValueCopyLabelAtIndex(addressValues, i).takeRetainedValue()
                        as CFString;
                    let localizedLabel = ABAddressBookCopyLocalizedLabel(label)
                        .takeRetainedValue() as String

                    let value = ABMultiValueCopyValueAtIndex(addressValues, i)
                    let addrNSDict:NSMutableDictionary = value!.takeRetainedValue()
                        as! NSMutableDictionary
                    let country:String = addrNSDict.value(forKey: kABPersonAddressCountryKey as String)
                        as? String ?? ""
                    let state:String = addrNSDict.value(forKey: kABPersonAddressStateKey as String)
                        as? String ?? ""
                    let city:String = addrNSDict.value(forKey: kABPersonAddressCityKey as String)
                        as? String ?? ""
                    let street:String = addrNSDict.value(forKey: kABPersonAddressStreetKey as String)
                        as? String ?? ""
                    let contryCode:String = addrNSDict
                        .value(forKey: kABPersonAddressCountryCodeKey as String) as? String ?? ""
                    print("  \(localizedLabel): Contry:\(country) State:\(state) ")
                    DEBUG.DEBUGPRINT(obj:"City:\(city) Street:\(street) ContryCode:\(contryCode) ")
                }
            }

            //获取纪念日
            let dateValues:ABMutableMultiValue? =
                ABRecordCopyValue(contact, kABPersonDateProperty).takeRetainedValue()
            if dateValues != nil {
                DEBUG.DEBUGPRINT(obj:"纪念日：")
                for i in 0 ..< ABMultiValueGetCount(dateValues){

                    // 获得标签名
                    let label = ABMultiValueCopyLabelAtIndex(emailValues, i).takeRetainedValue()
                        as CFString;
                    let localizedLabel = ABAddressBookCopyLocalizedLabel(label)
                        .takeRetainedValue() as String

                    let value = ABMultiValueCopyValueAtIndex(dateValues, i)
                    let date = (value?.takeRetainedValue() as? NSDate)?.description ?? ""
                    DEBUG.DEBUGPRINT(obj:"  \(localizedLabel):\(date)")
                }
            }

            //获取即时通讯(IM)
            let imValues:ABMutableMultiValue? =
                ABRecordCopyValue(contact, kABPersonInstantMessageProperty).takeRetainedValue()
            if imValues != nil {
                DEBUG.DEBUGPRINT(obj:"即时通讯(IM)：")
                for i in 0 ..< ABMultiValueGetCount(imValues){

                    // 获得标签名
                    let label = ABMultiValueCopyLabelAtIndex(imValues, i).takeRetainedValue()
                        as CFString;
                    let localizedLabel = ABAddressBookCopyLocalizedLabel(label)
                        .takeRetainedValue() as String

                    let value = ABMultiValueCopyValueAtIndex(imValues, i)
                    let imNSDict:NSMutableDictionary = value!.takeRetainedValue()
                        as! NSMutableDictionary
                    let serves:String = imNSDict
                        .value(forKey: kABPersonInstantMessageServiceKey as String) as? String ?? ""
                    let userName:String = imNSDict
                        .value(forKey: kABPersonInstantMessageUsernameKey as String) as? String ?? ""
                    DEBUG.DEBUGPRINT(obj:"  \(localizedLabel): Serves:\(serves) UserName:\(userName)")
                }
            }
            contacts.append(bean)
        }
        complete?(contacts)
    }



    private func canReadContact(complete:((String?)->Void)?)  {
        if #available(iOS 9.0, *) {
            switch CNContactStore.authorizationStatus(for: .contacts) {
            case .notDetermined:
                myContactStore.requestAccess(for: .contacts, completionHandler: { (finsh, error) in
                    if error == nil {
                        complete?(nil)
                    }else {
                        complete?(error.debugDescription)
                    }
                })
            case .authorized:
                complete?(nil)
            default:
                complete?("不被允许访问通讯录")
            }

        }else {
            let authStatus:ABAuthorizationStatus = ABAddressBookGetAuthorizationStatus()
            if authStatus == .notDetermined {
                ABAddressBookRequestAccessWithCompletion(self.addressBook, { (granted, error) in
                    if error == nil {
                        complete?(nil)
                    }else {
                        complete?(error.debugDescription)
                    }
                })
            }else if authStatus == .authorized {
                complete?(nil)
            }else {
                complete?("拒绝访问")
            }
        }
    }


    @available(iOS 9.0, *)
    func readContactsFromContactStore(_ contactStore:CNContactStore,complete:(([ContacntBean]?)->Void)?) {
        guard CNContactStore.authorizationStatus(for: .contacts) == .authorized else {
            return
        }

        let keys = [CNContactFamilyNameKey,CNContactGivenNameKey,CNContactPhoneNumbersKey]

        let fetch = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
        do {
            var contactBeans:[ContacntBean] = []
            try contactStore.enumerateContacts(with: fetch, usingBlock: { (contact, stop) in
                //姓名
                let bean = ContacntBean()
                let name = "\(contact.familyName)\(contact.givenName)"
                print(name)
                bean.contacntName = name
                //电话
                for labeledValue in contact.phoneNumbers {
                    let phoneNumber = (labeledValue.value as CNPhoneNumber).stringValue
                    print(phoneNumber)
                    bean.contacntNum.append(phoneNumber)
                }
                contactBeans.append(bean)
            })
            complete?(contactBeans)
        } catch let error as NSError {
            print(error)
            complete?(nil)
        }
    }

    private func goSeetingContact() {
        let appname =  SystemUtils.getAppName() == nil ? "应用程序":SystemUtils.getAppName()!
        let message = "请在\(appname)的\"设置-隐私-通讯录\"选项中，允许\(appname)访问你的通讯录。"
        alertUtils.showAlert(title: message, message: nil, leftText: "以后", rightText: "设置", leftCallback: nil) {[weak self] in
            if UIApplication.shared.canOpenURL(URL.init(string: UIApplication.openSettingsURLString)!) {
                OpenAppUtils.openApp(url: UIApplication.openSettingsURLString)
            }else {
                self?.alertUtils.showAlert(title: "打开设置失败，请手动操作", message: nil, leftText: "好的", rightText: nil, leftCallback: nil, rightCallback: nil)
            }
        }
    }

}

///通讯录bean
class ContacntBean: BaseBean {

    var contacntName:String = ""
    var contacntNum:[String] = []


}


