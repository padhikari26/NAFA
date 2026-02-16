import { Injectable, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as admin from 'firebase-admin';

@Injectable()
export class FirebaseService implements OnModuleInit {
  private firebaseApp: admin.app.App;

  constructor(private configService: ConfigService) { }

  onModuleInit() {

    try {
      this.firebaseApp = admin.app();
      console.log('Using existing Firebase app');
      return;
    } catch (error) {

      console.log('Initializing new Firebase app');
    }

    const firebaseConfig = {
      type: this.configService.get<string>('FIREBASE_TYPE'),
      project_id: this.configService.get<string>('FIREBASE_PROJECT_ID'),
      private_key_id: this.configService.get<string>('FIREBASE_PRIVATE_KEY_ID'),
      private_key: this.configService.get<string>('FIREBASE_PRIVATE_KEY')?.replace(/\\n/g, '\n'),
      client_email: this.configService.get<string>('FIREBASE_CLIENT_EMAIL'),
      client_id: this.configService.get<string>('FIREBASE_CLIENT_ID'),
      auth_uri: this.configService.get<string>('FIREBASE_AUTH_URI'),
      token_uri: this.configService.get<string>('FIREBASE_TOKEN_URI'),
      auth_provider_x509_cert_url: this.configService.get<string>('FIREBASE_AUTH_PROVIDER_X509_CERT_URL'),
      client_x509_cert_url: this.configService.get<string>('FIREBASE_CLIENT_X509_CERT_URL'),
    };

    this.firebaseApp = admin.initializeApp({
      credential: admin.credential.cert(firebaseConfig as admin.ServiceAccount),
      storageBucket: this.configService.get<string>('FIREBASE_STORAGE_BUCKET'),
    });
  }

  getAuth() {
    return this.firebaseApp.auth();
  }

  getFirestore() {
    return this.firebaseApp.firestore();
  }

  getStorage() {
    return this.firebaseApp.storage();
  }

  getMessaging() {
    return this.firebaseApp.messaging();
  }

  async sendNotificationToTopic(topic: string, message: admin.messaging.Message) {
    try {
      const response = await admin.messaging().send({
        ...message,
        topic: topic,
        android: {
          priority: 'high',
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
            },
          },
        }
      });
      return response;
    } catch (error) {
      console.error('Error sending notification:', error);
      throw new Error('Failed to send notification');
    }
  }
  async sendNotificationToTokens(tokens: string[], payload: admin.messaging.MessagingPayload) {
    try {
      const message: admin.messaging.MulticastMessage = {
        tokens,
        notification: payload.notification,
        data: payload.data,
      };
      const response = await admin.messaging().sendEachForMulticast(message);
      return response;
    } catch (error) {
      console.error('Error sending notification to tokens:', error);
      throw new Error('Failed to send notification to tokens');
    }
  }
}
