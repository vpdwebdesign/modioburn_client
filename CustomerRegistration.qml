import QtQuick 2.9
import QtQuick.Window 2.3
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtQuick.Controls.Material 2.2

import ModioBurn.Tools 1.0
import "Common"

Pane {

    Material.theme: Material.Dark

    property string pageTitle: qsTr("Customer Registration")
    property int fontSize: 16
    property int anchorsTopMargin: 22
    property int columnSpacing: 0

    property bool nameValid: false
    property bool phoneValid: false
    property bool emailValid: false
    property bool usernameValid: false
    property bool passwordValid: false
    property bool matchingPasswordValid: false
    property bool allGood: false

    property bool registrationSuccessful: false

    Colors {
        id: commonColors
    }

    PhoneCodeVerifier {
        id: phoneCodeVerifier
    }

    function codeRequest(phoneNum, commType)
    {
        phoneCodeVerifier.codeRequestMethod = commType
        phoneCodeVerifier.phoneNumber = phoneNum
        if (phoneCodeVerifier.codeRequest())
        {
            messageLabel.color = commonColors.success
            messageLabel.text = "Confirmation code sent. It might take up to 2 minutes to arrive. Please click RESEND if it doesn't."
            messageLabel.visible = true
        } else
        {
            messageLabel.color = commonColors.warning
            messageLabel.text = "There was a problem sending the confirmation code. Please click RESEND to try again."
            messageLabel.visible = true
        }
    }

    ColumnLayout {
        id: logoColumn
        height: parent.height
        width: Math.round(0.3 * parent.width)
        anchors.left: parent.left

        Image {
            id: logo
            anchors.centerIn: parent
            source: "qrc:/assets/icons/logo.png"
        }
    }

    ColumnLayout {
        id: formColumn
        height: parent.height
        anchors.left: logoColumn.right
        anchors.right: parent.right

        Rectangle {
            id: registrationForm
            width: Math.round(0.8 * parent.width)
            height: Math.round(0.85 * parent.height)
            anchors.centerIn: parent
            color: "#2e2f30"
            border.color: "#404244"
            border.width: 4
            opacity: 0.9

            Label {
                id: instructionsLabel
                anchors.top: parent.top
                anchors.topMargin: 15
                anchors.left: parent.left
                anchors.leftMargin: 40
                anchors.right: parent.right
                anchors.rightMargin: 40
                font.pixelSize: 14
                text: "Fill out the form below to get your brand new Modioburn"
                    + " customer account. As a Modioburn Customer you'll receive"
                    + " a ton of benefits, including latest offers, discounts and"
                    + " critical messages straight to your phone."
                wrapMode: Label.Wrap

            }

            ColumnLayout {
                id: nameColumn
                width: parent.width
                height: 40
                anchors.top: instructionsLabel.bottom
                anchors.topMargin: anchorsTopMargin
                spacing: columnSpacing

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        id: nameLabel
                        text: "Name"
                        anchors.left: parent.left
                        anchors.leftMargin: 40
                        font.pixelSize: fontSize
                    }

                    TextField {
                        id: nameTextField
                        anchors.left: nameLabel.right
                        anchors.leftMargin: 20
                        anchors.right: parent.right
                        anchors.rightMargin: 40
                        Layout.fillWidth: true
                        focus: true
                        selectByMouse: true
                        font.pixelSize: fontSize
                        validator: RegExpValidator {
                            // simple name verification regex. Accepts one or more
                            // words(one or more characters separated by a space character), but no special characters.
                            regExp: /([A-Za-z0-9']+[\ ]?)+/
                        }
                    }
                }

                Label {
                    id: nameErrorLabel
                    anchors.left: parent.left
                    anchors.leftMargin: nameLabel.width + 70
                    opacity: 0.0
                    font.pixelSize: 12
                    color: commonColors.warning
                    text: "Please fill in your name"
                }
            }

            RowLayout {
                id: genderRow
                width: parent.width
                anchors.top: nameColumn.bottom
                anchors.topMargin: anchorsTopMargin
                height: 30

                Label {
                    id: genderLabel
                    text: "Gender"
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    font.pixelSize: fontSize
                }

                ComboBox {
                    id: genderSelectComboBox
                    anchors.left: genderLabel.right
                    anchors.leftMargin: 20
                    model: ["Male", "Female", "Other"]
                }
            }

            ColumnLayout {
                id: phoneColumn
                width: parent.width
                height: 40
                anchors.top: genderRow.bottom
                anchors.topMargin: anchorsTopMargin
                spacing: columnSpacing

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        id: phoneLabel
                        text: "Phone (required)"
                        anchors.left: parent.left
                        anchors.leftMargin: 40
                        font.pixelSize: fontSize
                    }

                    TextField {
                        id: phoneTextField
                        anchors.left: phoneLabel.right
                        anchors.leftMargin: 20
                        anchors.right: parent.right
                        anchors.rightMargin: 40
                        Layout.fillWidth: true
                        placeholderText: "0712123456"
                        focus: true
                        selectByMouse: true
                        font.pixelSize: fontSize
                        validator: RegExpValidator {
                            regExp: /^0\d{9}/
                        }
                    }
               }

                Label {
                    id: phoneErrorLabel
                    anchors.left: parent.left
                    anchors.leftMargin: phoneLabel.width + 70
                    opacity: 0.0
                    font.pixelSize: 12
                    color: commonColors.warning
//                    text: (userManager.phoneTaken(phoneTextField.text)) ? "Phone number already registered" : "Please enter a valid phone number"
                }
            }

            ColumnLayout {
                id: emailColumn
                width: parent.width
                height: 40
                anchors.top: phoneColumn.bottom
                anchors.topMargin: anchorsTopMargin
                spacing: columnSpacing

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        id: emailLabel
                        text: "Email (optional)"
                        anchors.left: parent.left
                        anchors.leftMargin: 40
                        font.pixelSize: fontSize
                    }
                    TextField {
                        id: emailTextField
                        anchors.left: emailLabel.right
                        anchors.leftMargin: 20
                        anchors.right: parent.right
                        anchors.rightMargin: 40
                        Layout.fillWidth: true
                        placeholderText: "me@email.com"
                        selectByMouse: true
                        font.pixelSize: fontSize
                        validator: RegExpValidator {
                            // simple email address string verification regex. Accepts victor.paul@gmail.com, victor123@reallylongdomain.me,
                            // but not victor@gmail.co.ke, nor victor#$@anymail.coms
                            regExp: /[\w.]+\@[\w]+[.][A-Za-z]{2,3}/
                        }
                    }
               }

                Label {
                    id: emailErrorLabel
                    anchors.left: parent.left
                    anchors.leftMargin: emailLabel.width + 70
                    opacity: 0.0
                    font.pixelSize: 12
                    color: commonColors.warning
//                    text: (userManager.emailTaken(emailTextField.text.toLowerCase())) ? "Email already registered" : "Please enter a valid email address"
                }
            }

            ColumnLayout {
                id: usernameColumn
                width: parent.width
                height: 40
                anchors.top: emailColumn.bottom
                anchors.topMargin: anchorsTopMargin
                spacing: columnSpacing

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        id: usernameLabel
                        text: "Username"
                        anchors.left: parent.left
                        anchors.leftMargin: 40
                        font.pixelSize: fontSize
                    }

                    TextField {
                        id: usernameTextField
                        anchors.left: usernameLabel.right
                        anchors.leftMargin: 20
                        anchors.right: parent.right
                        anchors.rightMargin: 40
                        Layout.fillWidth: true
                        placeholderText: (genderSelectComboBox.currentText.toLowerCase() === "male") ? "goodboy1990" : "goodgirl1990"
                        focus: true
                        selectByMouse: true
                        font.pixelSize: fontSize
                        validator: RegExpValidator {
                            // simple username verification regex. Only accepts three or more alphanumeric or underscore characters
                            regExp: /[\w]{3,}/
                        }
                    }
               }

                Label {
                    id: usernameErrorLabel
                    anchors.left: parent.left
                    anchors.leftMargin: usernameLabel.width + 70
                    opacity: 0.0
                    font.pixelSize: 12
                    color: commonColors.warning
//                    text: (userManager.userExists(usernameTextField.text.toLowerCase())) ? "User already exists" : "Please enter three or more characters"
                }
            }

            ColumnLayout {
                id: passwordColumn
                width: parent.width
                height: 40
                anchors.top: usernameColumn.bottom
                anchors.topMargin: anchorsTopMargin
                spacing: columnSpacing

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        id: passwordLabel
                        text: "Password"
                        anchors.left: parent.left
                        anchors.leftMargin: 40
                        font.pixelSize: fontSize
                    }

                    TextField {
                        id: passwordTextField
                        anchors.left: passwordLabel.right
                        anchors.leftMargin: 20
                        anchors.right: parent.right
                        anchors.rightMargin: 40
                        Layout.fillWidth: true
                        focus: true
                        selectByMouse: true
                        font.pixelSize: fontSize
                        echoMode: "Password"
                        validator: RegExpValidator {
                            // simple password string verification regex. Only accepts five or more characters, except a newline.
                            regExp: /.{5,}/
                        }
                    }
               }

                Label {
                    id: passwordErrorLabel
                    anchors.left: parent.left
                    anchors.leftMargin: passwordLabel.width + 70
                    opacity: 0.0
                    font.pixelSize: 12
                    color: commonColors.warning
                    text: "Please enter five or more characters"
                }
            }

            ColumnLayout {
                id: matchingPasswordColumn
                width: parent.width
                height: 40
                anchors.top: passwordColumn.bottom
                anchors.topMargin: anchorsTopMargin
                spacing: columnSpacing

                RowLayout {
                    Layout.fillWidth: true

                    Label {
                        id: matchingPasswordLabel
                        text: "Re-enter Password"
                        anchors.left: parent.left
                        anchors.leftMargin: 40
                        font.pixelSize: fontSize
                    }

                    TextField {
                        id: matchingPasswordTextField
                        anchors.left: matchingPasswordLabel.right
                        anchors.leftMargin: 20
                        anchors.right: parent.right
                        anchors.rightMargin: 40
                        Layout.fillWidth: true
                        focus: true
                        selectByMouse: true
                        font.pixelSize: fontSize
                        echoMode: "Password"
                        validator: RegExpValidator {
                            // simple password string verification regex. Only accepts five or more characters, except a newline.
                            regExp: /.{5,}/
                        }
                    }
               }

                Label {
                    id: matchingPasswordErrorLabel
                    anchors.left: parent.left
                    anchors.leftMargin: matchingPasswordLabel.width + 70
                    opacity: 0.0
                    font.pixelSize: 12
                    color: commonColors.warning
                    text: "Please enter a matching password"
                }
            }

            RowLayout {
                id: buttonsRow
                width: parent.width
                height: 30
                anchors.top: matchingPasswordColumn.bottom
                anchors.topMargin: anchorsTopMargin

                Button {
                    id: resetButton
                    text: "Reset"
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    anchors.right: parent.horizontalCenter
                    anchors.rightMargin: 5
                    onClicked: {
                        nameTextField.clear()
                        phoneTextField.clear()
                        emailTextField.clear()
                        usernameTextField.clear()
                        passwordTextField.clear()
                        matchingPasswordTextField.clear()
                        nameTextField.focus = true
                    }
                }

                Button {
                    id: registerButton
                    text: "Register"
                    anchors.right: parent.right
                    anchors.rightMargin: 40
                    anchors.left: parent.horizontalCenter
                    anchors.leftMargin: 5
                    onClicked: {
                        // Check validity of required or non-required-but-filled text fields
                        nameValid = nameTextField.acceptableInput
                        phoneValid = phoneTextField.acceptableInput
                        emailValid = ((emailTextField.text.length == 0) || (emailTextField.text.length > 0 && emailTextField.acceptableInput))
                        usernameValid = usernameTextField.acceptableInput
                        passwordValid = passwordTextField.acceptableInput
                        matchingPasswordValid = (matchingPasswordTextField.acceptableInput && (passwordTextField.text === matchingPasswordTextField.text))

                        if (userManager.phoneTaken(phoneTextField.text))
                        {
                            phoneErrorLabel.text = "Phone number already registered"
                            phoneValid = false
                        }
                        else
                            phoneErrorLabel.text = "Please enter a valid phone number"

                        if (userManager.emailTaken(emailTextField.text.toLowerCase()))
                        {
                            emailErrorLabel.text = "Email address already registered"
                            emailValid = false
                        }
                        else
                            emailErrorLabel.text = "Please enter a valid email address"

                        if (userManager.userExists(usernameTextField.text.toLowerCase()))
                        {
                            usernameErrorLabel.text = "A user with that username already exists"
                            usernameValid = false
                        }
                        else
                            usernameErrorLabel.text = "Please enter three or more characters"

                        if (!nameValid)
                            nameErrorLabel.opacity = 1.0
                        else
                            nameErrorLabel.opacity = 0.0

                        if (!phoneValid)
                            phoneErrorLabel.opacity = 1.0
                        else
                            phoneErrorLabel.opacity = 0.0

                        if (!emailValid)
                            emailErrorLabel.opacity = 1.0
                        else
                            emailErrorLabel.opacity = 0.0

                        if (!usernameValid)
                            usernameErrorLabel.opacity = 1.0
                        else
                            usernameErrorLabel.opacity = 0.0

                        if (!passwordValid)
                            passwordErrorLabel.opacity = 1.0
                        else
                            passwordErrorLabel.opacity = 0.0

                        if (!matchingPasswordValid)
                            matchingPasswordErrorLabel.opacity = 1.0
                        else
                            matchingPasswordErrorLabel.opacity = 0.0

                        allGood = (nameValid && phoneValid && emailValid && usernameValid && passwordValid && matchingPasswordValid)

                        if (allGood)
                        {
                            accountRegConfirmationDialog.open()
                        }
                    }
                }
            }
        }


        Dialog {
            id: accountRegConfirmationDialog
            x: registrationForm.x + 20
            y: registrationForm.y + 20
            width: registrationForm.width - 40
            height: registrationForm.height - 40
            modal: true
            focus: true
            title: qsTr("Account Registration Confirmation")
            closePolicy: Popup.NoAutoClose

            Rectangle {
                color: "transparent"
                anchors.fill: parent

                Label {
                    id: instructionsLabel1
                    width: parent.width
                    text: "A 4-digit account registration code is being sent"
                        + " to the provided phone number. Please enter it below"
                        + " to confirm account registration with Modio Burn."
                    wrapMode: Label.Wrap
                }

                Label {
                    id: instructionsLabel2
                    width: parent.width
                    anchors.top: instructionsLabel1.bottom
                    anchors.topMargin: anchorsTopMargin
                    text: "Enter the 4-digit code below"
                    wrapMode: Label.Wrap
                }

                RowLayout {
                    id: codeInputRow
                    width: parent.width
                    height: 40
                    anchors.top: instructionsLabel2.bottom
                    anchors.topMargin: 10

                    Label {
                        id: codeLabel
                        font.pixelSize: 15
                        text: "Code"
                    }

                    TextField {
                        id: codeTextField
                        anchors.left: codeLabel.right
                        anchors.leftMargin: 20
                        placeholderText: "e.g. 1234"
                        focus: true
                        validator: RegExpValidator {
                            regExp: /\d{4}/
                        }
                    }

                    Button {
                        id: verifyCodeButton
                        anchors.left: codeTextField.right
                        anchors.leftMargin: 20
                        text: "Verify"
                        onClicked: {
                            if (codeTextField.acceptableInput)
                            {
                                if (phoneCodeVerifier.checkNetworkAvailability())
                                {
                                    phoneCodeVerifier.code = codeTextField.text
                                    if (phoneCodeVerifier.codeVerify())
                                    {
                                        userManager.name = nameTextField.text.toLowerCase()
                                        userManager.gender = genderSelectComboBox.currentText.toLowerCase()
                                        userManager.phone = phoneTextField.text
                                        userManager.email = emailTextField.text.toLowerCase()
                                        userManager.username = usernameTextField.text.toLowerCase()
                                        userManager.passStr = passwordTextField.text
                                        userManager.status = "active"

                                        if (userManager.addUser())
                                        {
                                            if (userManager.role.addUserRole(usernameTextField.text.toLowerCase(), "customer"))
                                            {
                                                registrationSuccessful = true
                                                messageLabel.color = commonColors.success
                                                messageLabel.text = "Registration successful. You're now an official ModioBurn Customer."
                                                                  + " Click the CLOSE button to return to the login screen."
                                                messageLabel.visible = true
                                                console.log("User added successfully")
                                            }
                                            else
                                            {
                                                console.log("Failed to add customer user role. Unknown reason. Try again.")
                                            }
                                        }
                                        else
                                        {
                                            messageLabel.color = commonColors.danger
                                            messageLabel.text = "Registration failed. Please re-enter the code and click VERIFY."
                                            messageLabel.visible = true
                                            console.log("Failed to add user. Unknown reason. Try again.")
                                        }

                                    }
                                    else
                                    {
                                        messageLabel.color = commonColors.warning
                                        messageLabel.text = "Wrong code. Please enter the 4-digit code you received on your phone "
                                                          + "or click the RESEND button to fetch a new code. SMS messages can take "
                                                          + "as long as 2 minutes to be delivered."
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
                                messageLabel.color = commonColors.warning
                                messageLabel.text = "Invalid code. Please enter the 4-digit code you received on your phone "
                                                  + "or click the RESEND button to fetch a new code. SMS messages can take "
                                                  + "as long as 2 minutes to be delivered."
                                messageLabel.visible = true
                            }
                        }
                    }

                    Button {
                        id: resendCodeButton
                        anchors.left: verifyCodeButton.right
                        anchors.leftMargin: 20
                        text: "Resend"
                        onClicked: {
                            messageLabel.visible = false
                            codeTextField.clear()

                            if (phoneCodeVerifier.checkNetworkAvailability())
                            {
                                codeRequest(phoneTextField.text, PhoneCodeVerifier.SMS)
                            }
                            else
                            {
                                messageLabel.color = commonColors.danger
                                messageLabel.text = "No network connection. Please ask the attendant for assistance."
                                messageLabel.visible = true
                            }
                        }
                    }

                }

                Label {
                    id: messageLabel
                    width: parent.width
                    anchors.top: codeInputRow.bottom
                    anchors.topMargin: anchorsTopMargin
                    wrapMode: Label.Wrap
                    visible: false
                }

            }

            onOpened: {
                if (phoneCodeVerifier.checkNetworkAvailability())
                {
                    codeRequest(phoneTextField.text, PhoneCodeVerifier.SMS)
                }
                else
                {
                    messageLabel.color = commonColors.danger
                    messageLabel.text = "No network connection. Please ask the attendant for assistance."
                    messageLabel.visible = true
                }

            }

            onRejected: function() {
                codeTextField.clear()
                messageLabel.visible = false

                nameTextField.clear()
                phoneTextField.clear()
                emailTextField.clear()
                usernameTextField.clear()
                passwordTextField.clear()
                matchingPasswordTextField.clear()
                nameTextField.focus = true

                if (registrationSuccessful)
                {
                    mainView.pop(null)
                }
            }

            standardButtons: Dialog.Close
        }
    }
}

