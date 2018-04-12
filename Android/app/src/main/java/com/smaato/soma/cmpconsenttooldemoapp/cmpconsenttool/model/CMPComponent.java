package com.smaato.soma.cmpconsenttooldemoapp.cmpconsenttool.model;

import android.support.annotation.NonNull;
import android.util.Base64;
import android.util.Log;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class CMPComponent {

    private SubjectToGdpr subjectToGdpr;
    private String consentString;
    private String purposes;
    private String vendors;

    /**
     * Creates an instance of this class
     *
     * @param subjectToGdpr subject to GDPR
     * @param consentString the consent string passed as a websafe base64-encoded string.
     */
    public CMPComponent(SubjectToGdpr subjectToGdpr, String consentString) {
        this.subjectToGdpr = subjectToGdpr;
        this.consentString = consentString;
        convertStringToBinary();
    }

    /**
     * @return Enum that indicates
     * 'CMPGDPRDisabled' – value 0, not subject to GDPR
     * 'CMPGDPREnabled' – value 1, subject to GDPR,
     * 'CMPGDPRUnknown'- value 2, unset.
     */
    public SubjectToGdpr getSubjectToGdpr() {
        return subjectToGdpr;
    }

    /**
     * @param subjectToGdpr Enum that indicates
     *                      'CMPGDPRDisabled' – value 0, not subject to GDPR
     *                      'CMPGDPREnabled' – value 1, subject to GDPR,
     *                      'CMPGDPRUnknown'- value 2, unset.
     */
    public void setSubjectToGdpr(SubjectToGdpr subjectToGdpr) {
        this.subjectToGdpr = subjectToGdpr;
    }

    /**
     * @return the consent string passed as a websafe base64-encoded string.
     */
    public String getConsentString() {
        return consentString;
    }

    /**
     * @param consentString the consent string passed as a websafe base64-encoded string.
     */
    public void setConsentString(String consentString) {
        this.consentString = consentString;
    }

    public boolean hasPurposeForPurposeId(int purposeId) {
        return isConsentGivenForValue(purposes.charAt(purposeId));
    }

    public String getVendors() {
        return vendors;
    }

    public String getPurposes() {
        return purposes;
    }

    /**
     * @param vendorIds the vendors ids that you would like to retrieve consent for.
     *                  We recommend that vendor ids to be a value between [1, maxVendorId].
     * @return map that contains consent given or not given ( 1/0 ) for each valid vendor id
     */
    public Map<String, Boolean> getVendorConsents(List<Integer> vendorIds) {
        Map<String, Boolean> vendorConsentsMap = new HashMap<>();

        if (vendorIds.size() < vendors.length()) {
            for (int j = 0; j < vendorIds.size(); j++) {
                if (vendorIds.get(j) <= vendors.length() && vendorIds.get(j) > 0) {
                    vendorConsentsMap.put(String.valueOf(vendorIds.get(j)), isConsentGivenForValue(vendors.charAt(vendorIds.get(j) - 1)));
                }
            }
        }

        return vendorConsentsMap;
    }

    /**
     * @param purposeIds the purpose ids that you would like to request consent for
     * @return map that contains consent given or not ( 1/0 )
     */
    public Map<String, Boolean> getPublisherConsents(List<Integer> purposeIds) {
        Map<String, Boolean> publisherConsentsMap = new HashMap<>();

        if (purposeIds.size() < purposes.length()) {
            for (int j = 0; j < purposeIds.size(); j++) {
                if (purposeIds.get(j) <= purposes.length() && purposeIds.get(j) > 0) {
                    publisherConsentsMap.put(String.valueOf(purposeIds.get(j)), isConsentGivenForValue(purposes.charAt(purposeIds.get(j) - 1)));
                }
            }
        }

        if (purposeIds.isEmpty()) {
            for (int i = 0; i < purposes.length(); i++) {
                publisherConsentsMap.put(String.valueOf(i + 1), isConsentGivenForValue(purposes.charAt(i)));
            }
        }

        return publisherConsentsMap;
    }

    private void convertStringToBinary() {
        byte[] bytes = new byte[0];
        try {
            String modifiedConsentString;
            modifiedConsentString = consentString.replaceAll("_", "/").replaceAll("-", "+");
            bytes = Base64.decode(modifiedConsentString, Base64.DEFAULT);
        } catch (IllegalArgumentException exception) {
            Log.d("CMPTool", "Invalid base64 consent string");
            return;
        }

        StringBuilder binary = convertBase64ToBinary(bytes);

        if (binary.length() > 142) {
            int maxVendorIdDecimal = Integer.parseInt(binary.substring(126, 142), 2);

            if (binary.charAt(142) == '0') {
                purposes = binary.substring(102, 126);
                vendors = binary.substring(143, 143 + maxVendorIdDecimal);
            }
        }
    }

    @NonNull
    private StringBuilder convertBase64ToBinary(byte[] bytes) {
        StringBuilder binary = new StringBuilder();

        for (byte b : bytes) {
            int val = b;
            for (int i = 0; i < 8; i++) {
                binary.append((val & 128) == 0 ? 0 : 1);
                val <<= 1;
            }
        }

        return binary;
    }

    private boolean isConsentGivenForValue(char value) {
        return '1' == value;
    }
}