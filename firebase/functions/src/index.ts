import * as functions from "firebase-functions";
import {
  onNewUserCreate,
  onUpdateUserInfo,
  onUpdateUserPassword
} from "./user/user";

export const onNewUserCreated = functions.auth.user().onCreate(onNewUserCreate);
export const updateUserInfo = functions.https.onRequest(onUpdateUserInfo);
export const updateUserPassword = functions.https.onRequest(
  onUpdateUserPassword
);
