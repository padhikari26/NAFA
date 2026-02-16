"use client"

import SecureLS from "secure-ls";

import dayjss from "dayjs";
import advancedFormat from "dayjs/plugin/advancedFormat";
import customParseFormat from "dayjs/plugin/customParseFormat";
import localeData from "dayjs/plugin/localeData";
import weekday from "dayjs/plugin/weekday";
import weekOfYear from "dayjs/plugin/weekOfYear";
import weekYear from "dayjs/plugin/weekYear";
dayjss.extend(customParseFormat);
dayjss.extend(advancedFormat);
dayjss.extend(weekday);
dayjss.extend(localeData);
dayjss.extend(weekOfYear);
dayjss.extend(weekYear);
export const dayjs = dayjss;

let ls: SecureLS | null = null;

const getSecureLS = () => {
    if (typeof window !== "undefined" && !ls) {
        ls = new SecureLS();
    }
    return ls;
};

export const setLocalStorage = (key: string, value: any) => {
    if (typeof window !== "undefined") {
        const secureLS = getSecureLS();
        if (secureLS) {
            secureLS.set(key, value);
        }
    }
};

export const getLocalStorage = (key: string) => {
    if (typeof window !== "undefined") {
        const secureLS = getSecureLS();
        if (secureLS) {
            return secureLS.get(key);
        }
    }
    return null;
};

export const removeLocalStorage = (key: string) => {
    if (typeof window !== "undefined") {
        const secureLS = getSecureLS();
        if (secureLS) {
            secureLS.remove(key);
        }
    }
};