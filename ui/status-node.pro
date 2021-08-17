QT += quick
QT += webchannel

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

lupdate_only{
SOURCES = *.qml \
          app/*.qml \
          shared/*.qml \
          imports/*.qml \
          shared/status/*.qml \
}

TRANSLATIONS += \
    i18n/base.ts \
    i18n/qml_en.ts \
    i18n/qml_fr.ts \
    i18n/qml_it.ts \
    i18n/qml_ko.ts \
    i18n/qml_ru.ts \
    i18n/qml_tr.ts \
    i18n/qml_es.ts \
    i18n/qml_id.ts \
    i18n/qml_de.ts \
    i18n/qml_pt_BR.ts \
    i18n/qml_fil.ts \
    i18n/qml_zh.ts \
    i18n/qml_zh_TW.ts \
    i18n/qml_ar.ts \
    i18n/qml_ur.ts

RESOURCES += \
    imports/Constants.qml \
    imports/Style.qml \
    main.qml

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH = $$PWD/imports

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH = $$PWD/imports

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

DISTFILES += \
    fonts/InterStatus/InterStatus-Black.otf \
    fonts/InterStatus/InterStatus-BlackItalic.otf \
    fonts/InterStatus/InterStatus-Bold.otf \
    fonts/InterStatus/InterStatus-BoldItalic.otf \
    fonts/InterStatus/InterStatus-ExtraBold.otf \
    fonts/InterStatus/InterStatus-ExtraBoldItalic.otf \
    fonts/InterStatus/InterStatus-ExtraLight.otf \
    fonts/InterStatus/InterStatus-ExtraLightItalic.otf \
    fonts/InterStatus/InterStatus-Italic.otf \
    fonts/InterStatus/InterStatus-Light.otf \
    fonts/InterStatus/InterStatus-LightItalic.otf \
    fonts/InterStatus/InterStatus-Medium.otf \
    fonts/InterStatus/InterStatus-MediumItalic.otf \
    fonts/InterStatus/InterStatus-Regular.otf \
    fonts/InterStatus/InterStatus-SemiBold.otf \
    fonts/InterStatus/InterStatus-SemiBoldItalic.otf \
    fonts/InterStatus/InterStatus-Thin.otf \
    fonts/InterStatus/InterStatus-ThinItalic.otf \
    Theme.qml \
    app/AppLayouts/Browser/BrowserLayout.qml \
    app/AppLayouts/Browser/BrowserDialog.qml \
    app/AppLayouts/Browser/DownloadView.qml \
    app/AppLayouts/Browser/FindBar.qml \
    app/AppLayouts/Chat/ChatColumn.qml \
    app/AppLayouts/Chat/ChatColumn/samples/MessagesData.qml \
    app/AppLayouts/Chat/ChatColumn/samples/StickerData.qml \
    app/AppLayouts/Chat/ChatColumn/samples/StickerPackData.qml \
    app/AppLayouts/Chat/ChatColumn/ChatInput.qml \
    app/AppLayouts/Chat/ChatColumn/ChatButtons.qml \
    app/AppLayouts/Chat/ChatColumn/ChatMessages.qml \
    app/AppLayouts/Chat/ChatColumn/EmptyChat.qml \
    app/AppLayouts/Chat/ChatColumn/Message.qml \
    app/AppLayouts/Chat/ChatColumn/ReplyArea.qml \
    app/AppLayouts/Chat/ChatColumn/TopBar.qml \
    app/AppLayouts/Chat/ChatColumn/qmldir \
    app/AppLayouts/Chat/ChatLayout.qml \
    app/AppLayouts/Chat/ContactsColumn.qml \
    app/AppLayouts/Chat/ContactsColumn/Channel.qml \
    app/AppLayouts/Chat/ContactsColumn/ChannelList.qml \
    app/AppLayouts/Chat/ContactsColumn/EmptyView.qml \
    app/AppLayouts/Chat/ContactsColumn/qmldir \
    app/AppLayouts/Chat/components/GroupChatPopup.qml \
    app/AppLayouts/Chat/components/PublicChatPopup.qml \
    app/AppLayouts/Chat/components/PrivateChatPopup.qml \
    app/AppLayouts/Chat/components/RenameGroupPopup.qml \
    app/AppLayouts/Chat/components/SuggestedChannel.qml \
    app/AppLayouts/Chat/components/StickerButton.qml \
    app/AppLayouts/Chat/components/StickerMarket.qml \
    app/AppLayouts/Chat/components/StickersPopup.qml \
    app/AppLayouts/Chat/components/StickerPackIconWithIndicator.qml \
    app/AppLayouts/Chat/components/qmldir \
    app/AppLayouts/Chat/qmldir \
    app/AppLayouts/Node/NodeLayout.qml \
    app/AppLayouts/Profile/LeftTab.qml \
    app/AppLayouts/Profile/LeftTab/Menu.qml \
    app/AppLayouts/Profile/LeftTab/Profile.qml \
    app/AppLayouts/Profile/LeftTab/qmldir \
    app/AppLayouts/Profile/ProfileLayout.qml \
    app/AppLayouts/Profile/Sections/Contacts/Contact.qml \
    app/AppLayouts/Profile/Sections/Contacts/ContactList.qml \
    app/AppLayouts/Profile/Sections/Contacts/qmldir \
    app/AppLayouts/Profile/Sections/Contacts/samples/ContactsData.qml \
    app/AppLayouts/Profile/Sections/Contacts/samples/qmldir \
    app/AppLayouts/Wallet/AccountSettingsModal.qml \
    app/AppLayouts/Wallet/AddCustomTokenModal.qml \
    app/AppLayouts/Wallet/AssetsTab.qml \
    app/AppLayouts/Wallet/CollectiblesTab.qml \
    app/AppLayouts/Wallet/components/AccountSettingsModal.qml \
    app/AppLayouts/Wallet/components/AddAccount.qml \
    app/AppLayouts/Wallet/components/AddAccountWithPrivateKey.qml \
    app/AppLayouts/Wallet/components/AddAccountWithSeed.qml \
    app/AppLayouts/Wallet/components/AddWatchOnlyAccount \
    app/AppLayouts/Wallet/components/AddWatchOnlyAccount.qml \
    app/AppLayouts/Wallet/components/GenerateAccountModal.qml \
    app/AppLayouts/Wallet/components/SendModalContent.qml \
    app/AppLayouts/Wallet/components/SetCurrencyModalContent.qml \
    app/AppLayouts/Wallet/components/TokenSettingsModalContent.qml \
    app/AppLayouts/Wallet/components/qmldir \
    app/AppLayouts/Wallet/HistoryTab.qml \
    app/AppLayouts/Profile/Sections/AboutContainer.qml \
    app/AppLayouts/Profile/Sections/AdvancedContainer.qml \
    app/AppLayouts/Profile/Sections/ContactsContainer.qml \
    app/AppLayouts/Profile/Sections/EnsContainer.qml \
    app/AppLayouts/Profile/Sections/HelpContainer.qml \
    app/AppLayouts/Profile/Sections/LanguageContainer.qml \
    app/AppLayouts/Profile/Sections/NotificationsContainer.qml \
    app/AppLayouts/Profile/Sections/PrivacyContainer.qml \
    app/AppLayouts/Profile/Sections/SignoutContainer.qml \
    app/AppLayouts/Profile/Sections/SyncContainer.qml \
    app/AppLayouts/Profile/Sections/DevicesContainer.qml \
    app/AppLayouts/Profile/Sections/qmldir \
    app/AppLayouts/Profile/qmldir \
    app/AppLayouts/Wallet/LeftTab.qml \
    app/AppLayouts/Wallet/SendModal.qml \
    app/AppLayouts/Wallet/SignPhraseModal.qml \
    app/AppLayouts/Wallet/SetCurrencyModal.qml \
    app/AppLayouts/Wallet/SeedPhraeBackupWarning.qml \
    app/AppLayouts/Wallet/TokenSettingsModal.qml \
    app/AppLayouts/Wallet/WalletHeader.qml \
    app/AppLayouts/Wallet/WalletLayout.qml \
    app/AppLayouts/Wallet/data/Currencies.qml \
    app/AppLayouts/Wallet/qmldir \
    app/AppLayouts/Wallet/tokens/Tokens.qml \
    app/AppLayouts/Wallet/tokens/qmldir \
    app/AppLayouts/WalletLayout.qml \
    app/AppLayouts/qmldir \
    app/AppMain.qml \
    app/img/arrow-btn-active.svg \
    app/img/arrow-btn-inactive.svg \
    app/img/compass.svg \
    app/img/compassActive.svg \
    app/img/group_chat.svg \
    app/img/hash.svg \
    app/img/history_icon.svg \
    app/img/message.svg \
    app/img/messageActive.svg \
    app/img/new_chat.svg \
    app/img/profile.svg \
    app/img/profileActive.svg \
    app/img/public_chat.svg \
    app/img/search.svg \
    app/img/wallet.svg \
    app/img/status-logo-no-bg.svg \
    app/img/stickers_icon.svg \
    app/img/stickers_icon_open.svg \
    app/img/stickers_sad_icon.svg \
    app/img/walletActive.svg \
    app/qmldir \
    imports/Emoji.qml \
    imports/Themes/DarkTheme.qml \
    imports/Themes/LightTheme.qml \
    imports/Themes/Theme.qml \
    imports/Themes/qmldir \
    imports/Utils.qml \
    imports/qmldir \
    onboarding/CreatePasswordModal.qml \
    onboarding/EnterSeedPhraseModal.qml \
    onboarding/ExistingKey.qml \
    onboarding/GenKey.qml \
    onboarding/GenKeyModal.qml \
    onboarding/KeysMain.qml \
    onboarding/Login.qml \
    onboarding/Login/AccountList.qml \
    onboarding/Login/AccountView.qml \
    onboarding/Login/ConfirmAddExistingKeyModal.qml \
    onboarding/Login/SelectAnotherAccountModal.qml \
    onboarding/Login/qmldir \
    onboarding/Login/samples/AccountsData.qml \
    onboarding/Login/samples/qmldir \
    onboarding/OnboardingMain.qml \
    onboarding/img/browser-dark@2x.jpg \
    onboarding/img/browser-dark@3x.jpg \
    onboarding/img/browser@2x.jpg \
    onboarding/img/browser@3x.jpg \
    onboarding/img/chat-dark@2x.jpg \
    onboarding/img/chat-dark@3x.jpg \
    onboarding/img/chat@2x.jpg \
    onboarding/img/chat@3x.jpg \
    onboarding/img/key.png \
    onboarding/img/key@2x.png \
    onboarding/img/next.svg \
    onboarding/img/wallet-dark@2x.jpg \
    onboarding/img/wallet-dark@3x.jpg \
    onboarding/img/wallet@2x.jpg \
    onboarding/img/wallet@3x.jpg \
    onboarding/qmldir \
    shared/AccountSelector.qml \
    shared/AddButton.qml \
    shared/Address.qml \
    shared/ContactsListAndSearch.qml \
    shared/CropCornerRectangle.qml \
    shared/DelegateModelGeneralized.qml \
    shared/FormGroup.qml \
    shared/GasSelectorButton.qml \
    shared/IconButton.qml \
    shared/ImageCropper.qml \
    shared/ImageCropperModal.qml \
    shared/Input.qml \
    shared/LabelValueRow.qml \
    shared/MacTrafficLights.qml \
    shared/ModalPopup.qml \
    shared/NotificationWindow.qml \
    shared/PopupMenu.qml \
    shared/Identicon.qml \
    shared/AssetAndAmountInput.qml \
    shared/CopyToClipBoardButton.qml \
    shared/GasSelector.qml \
    shared/GasValidator.qml \
    shared/RoundedImage.qml \
    shared/SearchBox.qml \
    shared/SeedPhraseTextArea.qml \
    shared/Select.qml \
    shared/SendToContractWarning.qml \
    shared/Separator.qml \
    shared/SeparatorWithIcon.qml \
    shared/SplitViewHandle.qml \
    shared/StatusTabButton.qml \
    shared/StyledButton.qml \
    shared/RoundedIcon.qml \
    shared/StyledText.qml \
    shared/StyledTextArea.qml \
    shared/StyledTextEdit.qml \
    shared/StyledTextField.qml \
    shared/SVGImage.qml \
    shared/TextWithLabel.qml \
    shared/ToastMessage.qml \
    shared/TransactionPreview.qml \
    shared/TransactionFormGroup.qml \
    shared/TransactionStackView.qml \
    shared/img/check.svg \
    shared/img/close.svg \
    shared/img/loading.png \
    shared/img/loading.svg \
    shared/img/status-logo.svg \
    shared/qmldir \
    shared/status/StatusChatInputTextFormationAction.qml \
    shared/status/StatusEmojiSuggestionPopup.qml \
    shared/status/StatusInputListPopup.qml \
    shared/status/StatusRadioButtonRow.qml \
    shared/status/StatusSettingsLineButton.qml \
    sounds/ErrorSound.qml
