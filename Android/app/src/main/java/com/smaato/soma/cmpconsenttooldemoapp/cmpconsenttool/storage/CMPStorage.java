package com.smaato.soma.cmpconsenttooldemoapp.cmpconsenttool.storage;

import android.content.Context;
import android.preference.PreferenceManager;
import android.text.TextUtils;

import com.smaato.soma.cmpconsenttooldemoapp.cmpconsenttool.model.CMPComponent;
import com.smaato.soma.cmpconsenttooldemoapp.cmpconsenttool.model.SubjectToGdpr;

import org.json.JSONObject;

import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Used to retrieve from SharedPreferences the consentData, subjectToGdpr and also CMPComponent
 */
public class CMPStorage {
    private static final String CONSENT_STRING = "IABConsent_ConsentString";
    private static final String SUBJECT_TO_GDPR = "IABConsent_SubjectToGDPR";
    private static final String VENDOR_LIST_JSON = "vendors";

    private static String consentString;
    private static int subjectToGdpr = 2;
    private static String vendorListJson;


    public static String getConsentString(Context context) {
        if (TextUtils.isEmpty(consentString)) {
            consentString = PreferenceManager.getDefaultSharedPreferences(context).getString(CONSENT_STRING, null);
        }

        return consentString;
    }

    public static void setConsentString(Context context, String consentString) {
        CMPStorage.consentString = consentString;
        PreferenceManager.getDefaultSharedPreferences(context).edit().putString(CONSENT_STRING, consentString).apply();
    }

    public static SubjectToGdpr getSubjectToGdpr(Context context) {
        if (PreferenceManager.getDefaultSharedPreferences(context).contains(SUBJECT_TO_GDPR)) {
            subjectToGdpr = PreferenceManager.getDefaultSharedPreferences(context).getInt(SUBJECT_TO_GDPR, 2);
        }

        return SubjectToGdpr.getValueForInteger(subjectToGdpr);
    }

    public static void setSubjectToGdpr(Context context, int subjectToGdpr) {
        CMPStorage.subjectToGdpr = subjectToGdpr;
        PreferenceManager.getDefaultSharedPreferences(context).edit().putInt(SUBJECT_TO_GDPR, subjectToGdpr).apply();
    }

    public static Map<String, Boolean> getVendorsMap(Context context) {
        String vendorsString = getVendorsString(context);
        return parseVendorsString(vendorsString);
    }

    public static String getVendorsString(Context context) {
        if (PreferenceManager.getDefaultSharedPreferences(context).contains(VENDOR_LIST_JSON)) {
            vendorListJson = PreferenceManager.getDefaultSharedPreferences(context).getString(VENDOR_LIST_JSON, vendorListJson);
        }

        return vendorListJson;
    }

    public static void setVendorsString(Context context, String vendorListJson) {
        CMPStorage.vendorListJson = vendorListJson;
        PreferenceManager.getDefaultSharedPreferences(context).edit().putString(VENDOR_LIST_JSON, vendorListJson).apply();
    }

    public static String getConsentData(Context context) {
        return CMPStorage.getConsentString(context);
    }

    public static CMPComponent getCMPComponent(Context context) {
        return new CMPComponent(CMPStorage.getSubjectToGdpr(context), CMPStorage.getConsentString(context));
    }

    private static Map<String, Boolean> parseVendorsString(String vendorsJsonString) {
        Map<String, Boolean> vendors = new LinkedHashMap<>();

        try {
            JSONObject jsonObject = new JSONObject(vendorsJsonString);
            Iterator<String> keys = jsonObject.keys();

            while (keys.hasNext()) {
                String key = keys.next();
                vendors.put(key, jsonObject.getBoolean(key));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return vendors;
    }
}
