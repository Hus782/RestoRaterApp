//
//  Lingo.swift
//  RestoRaterApp
//
//  Created by user249550 on 12/17/23.
//

import Foundation

// All labels used in the app
// This setup allows for an easy localization of the app and addition of multple languages
struct Lingo {
    // ProfileView labels
    static let profileViewTitle = String(localized: "profile_view_title")
    static let profileViewNoUserLoggedIn = String(localized: "profile_view_no_user_logged_in")
    static let profileViewLogoutButton = String(localized: "profile_view_logout_button")
    static let profileViewNameTitle = String(localized: "profile_view_name_title")
    static let profileViewEmailTitle = String(localized: "profile_view_email_title")
    static let profileViewRoleTitle = String(localized: "profile_view_role_title")
    static let profileViewAdminRole = String(localized: "profile_view_admin_role")
    static let profileViewRegularUserRole = String(localized: "profile_view_regular_user_role")
    
    //    Users tab labels
    static let usersListTitle = String(localized: "users_list_title")
    static let addEditUserName = String(localized: "add_edit_user_name")
    static let addEditUserEmail = String(localized: "add_edit_user_email")
    static let addEditUserPassword = String(localized: "add_edit_user_password")
    static let addEditUserAdminAccess = String(localized: "add_edit_user_admin_access")
    static let addEditUserSaveButton = String(localized: "add_edit_user_save_button")
    
}
