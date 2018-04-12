package com.smaato.soma.cmpconsenttooldemoapp.cmpconsenttool.model;

/**
 * Enum that indicates    'CMPGDPRDisabled' – value 0, not subject to GDPR
 * 'CMPGDPREnabled' – value 1, subject to GDPR,
 * 'CMPGDPRUnknown'- value 2, unset.
 */
public enum SubjectToGdpr {
    CMPGDPRUnknown(2), CMPGDPRDisabled(0), CMPGDPREnabled(1);
    private final int value;

    SubjectToGdpr(int value) {
        this.value = value;
    }

    public static SubjectToGdpr getValueForInteger(final int valueInt) {
        for (int i = 0; i < values().length; ++i) {

            SubjectToGdpr value = values()[i];
            if (value.value == valueInt) {
                return value;
            }
        }
        return null;
    }

    public int getValue() {
        return value;
    }
}
