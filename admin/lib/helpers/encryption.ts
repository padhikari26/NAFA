import CryptoJS from "crypto-js";

const secretKey = "1b2613097d730a14d6cac665cbeg0a15";
const iv = "1090152305672910";

export const encryptString = (plainText: any) => {
    const key = CryptoJS.enc.Utf8.parse(secretKey);
    const ivParsed = CryptoJS.enc.Utf8.parse(iv);

    const encrypted = CryptoJS.AES.encrypt(plainText, key, {
        iv: ivParsed,
        padding: CryptoJS.pad.AnsiX923,
        mode: CryptoJS.mode.CBC,
    });

    return encrypted.toString();
};

export const decryptString = (cipherText: any) => {
    const key = CryptoJS.enc.Utf8.parse(secretKey);
    const ivParsed = CryptoJS.enc.Utf8.parse(iv);

    if (cipherText) {
        const decrypted = CryptoJS.AES.decrypt(cipherText, key, {
            iv: ivParsed,
            padding: CryptoJS.pad.Pkcs7,
            mode: CryptoJS.mode.CBC,
        });
        return decrypted.toString(CryptoJS.enc.Utf8);
    } else return "";

};
