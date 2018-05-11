import QtQuick 2.9
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2
import ModioBurn.Tools 1.0

import "Common"

Pane {

    Material.theme: Material.Dark

    property string pageTitle: qsTr("Welcome to Modio Burn")

    // Properties for use in the code confirmation dialog to reset forgotten password
    property bool codeAccepted: false
    property bool unameValid: false
    property bool phoneValid: false
    property bool codeValid: false
    property bool newPasswordValid: false
    property bool matchingNewPasswordValid: false
    property bool allGood: false

    Colors {
        id: commonColors
    }

    clip: true
    background: Image {
        id: loginBg
        anchors.fill: parent
        source: "qrc:/assets/posters/loginbg.jpg"

    }

    RowLayout {
        id: login
        width: Math.round(0.4 * parent.width)
        height: 560
        anchors.centerIn: parent

        Rectangle {
            id: loginForm
            anchors.fill: parent
            color: "#2e2f30"
            border.color: "#404244"
            border.width: 2
            opacity: 0.9


            RowLayout {
                id: logoRow
                width: parent.width
                height: 210
                anchors.top: parent.top
                anchors.topMargin: 10

                Image {
                    id: logo
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "qrc:/assets/icons/logo.png"
                }
            }

            RowLayout {
                id: titleRow
                width: parent.width
                anchors.top: logoRow.bottom
                anchors.topMargin: 20
                height: 40

                Label {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    font.pixelSize: 25
                    color: "#e0e0e0"
                    text: "Login"
                }
            }

            RowLayout {
                id: usernameRow
                spacing: 10
                width: parent.width
                anchors.top: titleRow.bottom
                anchors.topMargin: 30
                height: 50

                Label {
                    id: usernameLabel
                    text: "Username"
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }

                TextField {
                    id: usernameTextField
                    anchors.left: usernameLabel.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    Layout.fillWidth: true
                    placeholderText: "Enter your username or phone number"
                    focus: true
                    selectByMouse: true
                    onAccepted: passwordTextField.focus = true
                }
            }

            RowLayout {
                id: passwordRow
                spacing: 10
                width: parent.width
                height: 50
                anchors.top: usernameRow.bottom
                anchors.topMargin: 10

                Label {
                    id: passwordLabel
                    text: "Password"
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                }

                TextField {
                    id: passwordTextField
                    anchors.left: passwordLabel.right
                    anchors.leftMargin: 10
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    Layout.fillWidth: true
                    echoMode: TextInput.Password
                    placeholderText: "Enter your password"
                    selectByMouse: true
                    onAccepted: function() {
                        var enteredName = usernameTextField.text.toLowerCase()
                        var enteredPassword = passwordTextField.text

                        if (enteredName.length > 0 && enteredPassword.length > 0) {
                            if (userManager.authenticate(enteredName, enteredPassword)) {
                                if (userManager.session.role.toLowerCase() === "customer")
                                {
                                    usernameTextField.clear()
                                    passwordTextField.clear()

                                    name = userManager.name
                                    username = userManager.session.username
                                    role = userManager.session.role
                                    loggedIn = userManager.session.loggedIn
                                    mbTimer.init()
                                    mainView.push("CustomerHome.qml")
                                }
                                else
                                {
                                    genericErrorDialog.title = "Only Guest/Customer Logins Allowed"
                                    genericErrorMessage.text = "The system has detected that you're a ModioBurn official. Please log in at the server."
                                    genericErrorDialog.open()

                                    userManager.session.stop()
                                    loggedIn = userManager.session.loggedIn
                                    role = userManager.session.role
                                    username = userManager.session.username
                                    name = userManager.name
                                }
                            } else {
                                genericErrorDialog.title = "Wrong Credentials"
                                genericErrorMessage.text = "Please enter the correct credentials to log in"
                                genericErrorDialog.open()
                            }
                        } else {
                            genericErrorDialog.title = "Missing Info"
                            genericErrorMessage.text = "Please fill in both the username and password fields to log in"
                            genericErrorDialog.open()
                        }
                    }
                }
            }

            RowLayout {
                id: forgotPasswordRow
                width: parent.width
                height: 10
                anchors.top: passwordRow.bottom
                anchors.topMargin: 5

                Text {
                    id: forgotPasswordLink
                    color: "#3bc9db"
                    text: qsTr("Forgot Password?")
                    anchors.right: parent.right
                    anchors.rightMargin: 10

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: forgotPasswordLink.color = "#99e9f2"
                        onExited: forgotPasswordLink.color = "#3bc9db"
                        onClicked: function() {
                            forgotPasswordDialog.open()
                        }
                    }
                }
            }

            RowLayout {
                id: buttonsRow
                width: parent.width
                height: 50
                anchors.top: forgotPasswordRow.bottom
                anchors.topMargin: 20

                Button {
                    id: resetButton
                    text: "Reset"
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.right: parent.horizontalCenter
                    anchors.rightMargin: 3
                    onClicked: function() {
                        usernameTextField.clear()
                        passwordTextField.clear()
                        usernameTextField.focus = true
                    }
                }

                Button {
                    id: loginButton
                    text: "Login"
                    anchors.right: parent.right
                    anchors.rightMargin: 10
                    anchors.left: parent.horizontalCenter
                    anchors.leftMargin: 3
                    onClicked: function() {
                        var enteredName = usernameTextField.text.toLowerCase()
                        var enteredPassword = passwordTextField.text

                        if (enteredName.length > 0 && enteredPassword.length > 0) {
                            if (userManager.authenticate(enteredName, enteredPassword)) {
                                if (userManager.session.role.toLowerCase() === "customer")
                                {
                                    usernameTextField.clear()
                                    passwordTextField.clear()

                                    name = userManager.name
                                    username = userManager.session.username
                                    role = userManager.session.role
                                    loggedIn = userManager.session.loggedIn
                                    mbTimer.init()
                                    mainView.push("CustomerHome.qml")
                                }
                                else
                                {
                                    usernameTextField.clear()
                                    passwordTextField.clear()
                                    genericErrorDialog.title = "Only Guest/Customer Logins Allowed"
                                    genericErrorMessage.text = "The system has detected that you're a ModioBurn official. Please log in at the server."
                                    genericErrorDialog.open()

                                    userManager.session.stop()
                                    loggedIn = userManager.session.loggedIn
                                    role = userManager.session.role
                                    username = userManager.session.username
                                    name = userManager.name
                                }
                            } else {
                                genericErrorDialog.title = "Wrong Credentials"
                                genericErrorMessage.text = "Please enter the correct credentials to log in"
                                genericErrorDialog.open()
                            }
                        } else {
                            genericErrorDialog.title = "Missing Info"
                            genericErrorMessage.text = "Please fill in both the username and password fields to log in"
                            genericErrorDialog.open()
                        }
                    }
                }
            }

            RowLayout {
                id: loginOptionsRow
                width: parent.width
                height: 10
                anchors.top: buttonsRow.bottom
                anchors.topMargin: 10

                Text {
                    id: guestLoginLink
                    color: "#3bc9db"
                    text: qsTr("Login As Guest")
                    anchors.left: parent.left
                    anchors.leftMargin: 10

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: guestLoginLink.color = "#99e9f2"
                        onExited: guestLoginLink.color = "#3bc9db"
                        onClicked: guestPreLoginDialog.open()
                    }
                }

                Text {
                    id: registerLink
                    color: "#3bc9db"
                    text: qsTr("Register")
                    anchors.right: parent.right
                    anchors.rightMargin: 10

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onEntered: registerLink.color = "#99e9f2"
                        onExited: registerLink.color = "#3bc9db"
                        onClicked: function() {
                            mainView.push("CustomerRegistration.qml")
                        }
                    }
                }
            }

        }
    }

    Dialog {
        id: guestPreLoginDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: 320
        parent: ApplicationWindow.overlay
        modal: true
        title: "Registration Benefits"
        standardButtons: Dialog.Ok
        onAccepted: {
            usernameTextField.clear()
            passwordTextField.clear()
            userManager.initGuest()
            loggedIn = userManager.session.loggedIn
            role = userManager.session.role
            username = userManager.session.username
            name = username
            mbTimer.init()
            mainView.push("CustomerHome.qml")
        }

        Column {
            id: column
            spacing: 20
            width: parent.width

            Label {
                width: parent.width
                text: "By logging in as a guest you will be able to access"
                    + " our content and make purchases.\n\n"
                    + "However, to get the full Modio Burn Customer experience you"
                    + " are advised to register an account with us.\n\n"
                    + "Benefits include:\n\n"
                    + "1. Customer loyalty rewards\n\n"
                    + "2. Access to a third payment option, namely your balance"
                    + " from a previous purchase\n\n"
                    + "3. Enjoy these benefits in any shop that uses the Modio Burn"
                    + " system"
                wrapMode: Label.Wrap
            }
        }
    }

    Dialog {
        id: forgotPasswordDialog
        x: login.x + 10
        y: login.y + 10
        width: login.width - 20
        height: login.height - 20
        modal: true
        focus: true
        title: qsTr("Reset Password")
        closePolicy: Popup.NoAutoClose

        Label {
            id: instructionsLabel
            width: parent.width
            text: qsTr("Please enter the username and phone number you used to register an account "
                       + "with us to receive a 4-digit code that you can use to reset your password")
            wrapMode: Label.Wrap
        }

        ColumnLayout {
            id: unameColumn
            width: parent.width
            height: 40
            anchors.top: instructionsLabel.bottom
            anchors.topMargin: 10
            spacing: 0

            RowLayout {
                Layout.fillWidth: true

                Label {
                    id: unameLabel
                    text: "Username"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    font.pixelSize: 16
                }

                TextField {
                    id: unameTextField
                    anchors.left: unameLabel.right
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    anchors.rightMargin: 20
                    Layout.fillWidth: true
                    focus: true
                    selectByMouse: true
                    font.pixelSize: 16
                    validator: RegExpValidator {
                        // simple username verification regex. Only accepts three or more alphanumeric or underscore characters
                        regExp: /[\w]{3,}/
                    }
                }
           }

            Label {
                id: unameErrorLabel
                anchors.left: parent.left
                anchors.leftMargin: unameLabel.width + 50
                opacity: 0.0
                font.pixelSize: 12
                color: commonColors.warning
                text: "Please enter a valid username"
            }
        }

        ColumnLayout {
            id: phoneColumn
            width: parent.width
            height: 40
            anchors.top: unameColumn.bottom
            anchors.topMargin: 20
            spacing: 0

            RowLayout {
                Layout.fillWidth: true

                Label {
                    id: phoneLabel
                    text: "Phone"
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    font.pixelSize: 16
                }

                TextField {
                    id: phoneTextField
                    anchors.left: phoneLabel.right
                    anchors.leftMargin: 20
                    anchors.right: getCodeButton.left
                    anchors.rightMargin: 20
                    Layout.fillWidth: true
                    placeholderText: "0712123456"
                    focus: true
                    selectByMouse: true
                    font.pixelSize: 16
                    validator: RegExpValidator {
                        regExp: /^07\d{8}/
                    }
                }

                Button {
                    id: getCodeButton
//                    anchors.right: parent.right
                    text: "Get Code"
                    onClicked: {
                        unameValid = unameTextField.acceptableInput
                        phoneValid = phoneTextField.acceptableInput

                        if (!unameValid)
                            unameErrorLabel.opacity = 1.0
                        else
                            unameErrorLabel.opacity = 0.0

                        if (!phoneValid)
                            phoneErrorLabel.opacity = 1.0
                        else
                            phoneErrorLabel.opacity = 0.0

                        allGood = (unameValid && phoneValid)

                        if (allGood)
                        {
                            if (userManager.verifyPhone(unameTextField.text.toLowerCase(), phoneTextField.text))
                            {
                                codeTextField.clear()
                                codeInputColumn.visible = true
                                codeTextField.focus = true
                                if (phoneCodeVerifier.checkNetworkAvailability())
                                {
                                    phoneCodeVerifier.codeRequestMethod = PhoneCodeVerifier.SMS
                                    phoneCodeVerifier.phoneNumber = phoneTextField.text
                                    if (phoneCodeVerifier.codeRequest())
                                    {
                                        messageLabel.color = commonColors.success
                                        messageLabel.text = "Code Sent. It might take up to 2 mins to arrive. Click GET CODE to resend it if it doesn't."
                                        messageLabel.visible = true
                                    } else {
                                        messageLabel.color = commonColors.danger
                                        messageLabel.text = "Cannot request for code. Click GET CODE to try again."
                                        messageLabel.visible = true
                                    }
                                }
                                else
                                {
                                    messageLabel.color = commonColors.danger
                                    messageLabel.text = "No network connection. Please ask the attendant for assistance."
                                    messageLabel.visible = true
                                }
                            }
                            else
                            {
                                codeTextField.clear()
                                codeInputColumn.visible = false
                                messageLabel.color = commonColors.warning
                                messageLabel.text = "That is not the phone number you used to register an account with us. Please try again."
                                messageLabel.visible = true
                            }
                        }
                        else
                        {
                            codeTextField.clear()
                            codeInputColumn.visible = false
                            phoneErrorLabel.opacity = 1.0
                        }
                    }
                }
           }

            Label {
                id: phoneErrorLabel
                anchors.left: parent.left
                anchors.leftMargin: phoneLabel.width + 20
                opacity: 0.0
                font.pixelSize: 12
                color: commonColors.warning
                text: "Please enter a valid phone number"
            }
        }

        ColumnLayout {
            id: codeInputColumn
            width: parent.width
            height: 40
            anchors.top: phoneColumn.bottom
            anchors.topMargin: 20
            spacing: 0
            visible: false

            RowLayout {
                Layout.fillWidth: true

                Label {
                    id: codeLabel
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    font.pixelSize: 16
                    text: "Code"
                }

                TextField {
                    id: codeTextField
                    anchors.left: codeLabel.right
                    anchors.leftMargin: 20
                    placeholderText: "e.g. 1234"
                    validator: RegExpValidator {
                        regExp: /\d{4}/
                    }
                }

                Button {
                    anchors.left: codeTextField.right
                    anchors.leftMargin: 20
                    text: "Verify"
                    onClicked: {
                        newPasswordColumn.visible = false
                        confirmNewPasswordColumn.visible = false
                        confirmNewPasswordButtonRow.visible = false

                        codeValid = codeTextField.acceptableInput

                        if (!codeValid)
                            codeInputErrorLabel.opacity = 1.0
                        else
                        {
                            codeInputErrorLabel.opacity = 0.0

                            if (phoneCodeVerifier.checkNetworkAvailability())
                            {
                                phoneCodeVerifier.code = codeTextField.text
                                if (phoneCodeVerifier.codeVerify())
                                {
                                    messageLabel.color = commonColors.success
                                    messageLabel.text = "Code verification successful. Enter new password."
                                    messageLabel.visible = true

                                    newPasswordColumn.visible = true
                                    confirmNewPasswordColumn.visible = true
                                    confirmNewPasswordButtonRow.visible = true
                                }
                                else
                                {
                                    newPasswordColumn.visible = false
                                    confirmNewPasswordColumn.visible = false
                                    confirmNewPasswordButtonRow.visible = false
                                    messageLabel.color = commonColors.warning
                                    messageLabel.text = "Code verification not successful. Please try again."
                                    messageLabel.visible = true
                                }
                            }
                            else
                            {
                                newPasswordColumn.visible = false
                                confirmNewPasswordColumn.visible = false
                                confirmNewPasswordButtonRow.visible = false
                                messageLabel.text = "No network connection. Please ask the attendant for assistance."
                                messageLabel.visible = true
                            }

                        }
                    }
                }

            }

            Label {
                id: codeInputErrorLabel
                anchors.left: parent.left
                anchors.leftMargin: codeLabel.width + 20
                wrapMode: Label.Wrap
                text: "Please enter a valid code"
                color: commonColors.warning
                opacity: 0.0
            }
        }

        ColumnLayout {
            id: newPasswordColumn
            width: parent.width
            height: 35
            anchors.top: codeInputColumn.bottom
            anchors.topMargin: 20
            spacing: 0
            visible: false

            RowLayout {
                Layout.fillWidth: true

                Label {
                    id: newPasswordLabel
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    font.pixelSize: 16
                    text: "New Password"
                }

                TextField {
                    id: newPasswordTextField
                    anchors.left: newPasswordLabel.right
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    Layout.fillWidth: true
                    echoMode: TextInput.Password
                    selectByMouse: true
                    validator: RegExpValidator {
                        // simple password string verification regex. Only accepts five or more characters, except a newline.
                        regExp: /.{5,}/
                    }
                }
           }

            Label {
                id: newPasswordErrorLabel
                anchors.left: parent.left
                anchors.leftMargin: newPasswordLabel.width + 50
                opacity: 0.0
                font.pixelSize: 12
                color: commonColors.warning
                text: "Please enter five or more characters"
            }
        }

        ColumnLayout {
            id: confirmNewPasswordColumn
            width: parent.width
            height: 35
            anchors.top: newPasswordColumn.bottom
            anchors.topMargin: 20
            spacing: 0
            visible: false

            RowLayout {
                Layout.fillWidth: true

                Label {
                    id: confirmNewPasswordLabel
                    anchors.left: parent.left
                    anchors.leftMargin: 20
                    font.pixelSize: 16
                    text: "Confirm Password"
                }

                TextField {
                    id: confirmNewPasswordTextField
                    anchors.left: confirmNewPasswordLabel.right
                    anchors.leftMargin: 20
                    anchors.right: parent.right
                    Layout.fillWidth: true
                    echoMode: TextInput.Password
                    selectByMouse: true
                    validator: RegExpValidator {
                        // simple password string verification regex. Only accepts five or more characters, except a newline.
                        regExp: /.{5,}/
                    }
                }
           }

            Label {
                id: confirmNewPasswordErrorLabel
                anchors.left: parent.left
                anchors.leftMargin: confirmNewPasswordLabel.width + 50
                opacity: 0.0
                font.pixelSize: 12
                color: commonColors.warning
                text: "Please enter a matching password"
            }
        }

        RowLayout {
            id: confirmNewPasswordButtonRow
            width: parent.width
            height: 20
            anchors.top: confirmNewPasswordColumn.bottom
            visible: false

            Button {
                anchors.right: parent.right
                width: Math.round(0.5 * parent.width)
                text: "Change Password"
                onClicked: {
                    newPasswordValid = newPasswordTextField.acceptableInput
                    matchingNewPasswordValid = (confirmNewPasswordTextField.acceptableInput &&
                                                (confirmNewPasswordTextField.text === newPasswordTextField.text))

                    if (!newPasswordValid)
                        newPasswordErrorLabel.opacity = 1.0
                    else
                        newPasswordErrorLabel.opacity = 0.0

                    if (!matchingNewPasswordValid)
                        confirmNewPasswordErrorLabel.opacity = 1.0
                    else
                        confirmNewPasswordErrorLabel.opacity = 0.0

                    if (newPasswordValid && matchingNewPasswordValid)
                    {
                        if (userManager.resetPassword(unameTextField.text.toLowerCase(), newPasswordTextField.text)) {
                            messageLabel.color = commonColors.success
                            messageLabel.text = "Password reset successful. Please try to log in."
                            messageLabel.visible = true
                        }
                        else
                        {
                            messageLabel.color = commonColors.danger
                            messageLabel.text = "There was a problem resetting your password. Try again."
                            messageLabel.visible = true
                        }

                    }
                    else
                    {
                        messageLabel.color = commonColors.warning
                        messageLabel.text = "Please enter valid matching passwords."
                        messageLabel.visible = true
                    }
                }
            }

        }

        Label {
            id: messageLabel
            width: parent.width
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.bottom: parent.bottom
            wrapMode: Label.Wrap
        }

        onRejected: function() {
            unameTextField.clear()
            phoneTextField.clear()
            codeTextField.clear()
            newPasswordTextField.clear()
            confirmNewPasswordTextField.clear()
            messageLabel.visible = false
            codeInputColumn.visible = false
            newPasswordColumn.visible = false
            confirmNewPasswordColumn.visible = false
            confirmNewPasswordButtonRow.visible = false
        }

        standardButtons: Dialog.Close
    }

    Dialog {
        id: genericErrorDialog
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        width: Math.round(0.8 * login.width)
        modal: true
        focus: true
        Label {
            id: genericErrorMessage
            width: parent.width
            wrapMode: Label.Wrap
        }
        standardButtons: Dialog.Close
    }
}

