# Implementation Guide for Android App Publishers


* Configure the consent tool by providing a set of properties encapsulated in the `CMPSettings` object. Where:

	* `SubjectToGdpr`: Enum that indicates
		* `CMPGDPRDisabled` - value 0, not subject to GDPR
		* `CMPGDPREnabled` - value 1, subject to GDPR
		* `CMPGDPRUnknown` - value 2, unset
	* `consentToolURL`: `String url` that is used to create and load the request into the `WKWebView` – it is the request for the consent webpage. This property is mandatory.
	* `consentString`: If this property is given, it enforces reinitialization with the given string, configured based on the `consentToolURL`. This property is optional.

```
CMPSettings cmpSettings = new CMPSettings(SubjectToGdpr.CMPGDPREnabled, “https://consentWebPage”, null);
```

* In order to start the `CMPConsentToolActivity`, you can call the following method:	`CMPConsentToolActivity.openCmpConsentToolView(cmpSettings, context, onCloseCallback);`
* In order to receive a callback when close or done button is tapped, you may use `OnCloseCallback` listener, otherwise pass null as the third parameter to openCMPConsentToolView().
* `SubjectToGdpr` and `consentString` will be stored in SharedPreferences


# Implementation Guide for Android SDK’s


* In order to retrieve the stored consent information from SharedPreferences, CMPStorage class provides the getCMPComponent(context) method which encapsulates GDPR information into CMPComponent object as follows:
    * subjectToGdpr: Enum that indicates
         * `CMPGDPRDisabled`- value 0, not subject to GDPR
         * `CMPGDPREnabled` - value 1, subject to GDPR
         * `CMPGDPRUnknown` - value 2, unset
    * consentString: The consent string as a websafe base64-encoded string.
    * purposes: String of purposes created from a subset of the decoded consentString converted to binary
    * vendors: String of vendors created from a subset of the decoded consentString converted to binary
* SubjectToGdpr default value is `CMPGDPRUnknown`.
* gdprConsent is null, if no consent has been stored in SharedPreferences.
* In order to retrieve the stored consent string from SharedPreferences, `CMPStorage` class provides the `getConsentData(context)` method. 
