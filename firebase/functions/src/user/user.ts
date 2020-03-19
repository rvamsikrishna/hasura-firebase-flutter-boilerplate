import * as admin from "firebase-admin";

import {
  insertUserMutation,
  updateUserMutation
} from "../graphQL/mutations/user/userMutations";

admin.initializeApp();

export const onNewUserCreate = async (user: any) => {
  const customClaims = {
    "https://hasura.io/jwt/claims": {
      "x-hasura-default-role": "user",
      "x-hasura-allowed-roles": ["admin", "user"],
      "x-hasura-user-id": user.uid
    }
  };

  try {
    await admin.auth().setCustomUserClaims(user.uid, customClaims);
    await insertUserMutation(user);
    await admin
      .firestore()
      .collection("user-meta")
      .doc(user.uid)
      .create({
        refreshTime: admin.firestore.FieldValue.serverTimestamp()
      });
  } catch (error) {
    throw new Error(error);
  }
};

export const onUpdateUserInfo = async (req: any, res: any) => {
  if (req.method !== "PUT") {
    res.status(405).send("HTTP Method " + req.method + " not allowed");
  }
  const userId = req.get("userId");
  if (!userId) {
    res.status(400).send({ error: "Please provide user id" });
    return;
  }
  const { displayName, photoURL, email, phoneNumber } = req.body;
  let user;
  try {
    const userRecord = await admin.auth().getUser(userId);

    user = await admin.auth().updateUser(userId, {
      email: email || userRecord.email,
      phoneNumber: phoneNumber || userRecord.phoneNumber,
      displayName: displayName || userRecord.displayName,
      photoURL: photoURL || userRecord.photoURL
    });

    await updateUserMutation(user);

    res.status(200).send(user);
  } catch (error) {
    res.status(500).send({ error: error.message });
  }

  return user;
};

export const onUpdateUserPassword = async (req: any, res: any) => {
  if (req.method !== "PUT") {
    res.status(405).send("HTTP Method " + req.method + " not allowed");
  }
  const userId = req.get("userId");
  if (!userId) {
    res.status(400).send({ error: "Please provide user id" });
    return;
  }
  const { password } = req.body;
  let user;
  try {
    user = await admin.auth().updateUser(userId, {
      password: password
    });
    res.status(200).send({ user: user });
  } catch (error) {
    res.status(500).send({ error: error.message });
  }
  return user;
};
