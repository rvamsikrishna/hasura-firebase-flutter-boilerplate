import gql from "graphql-tag";
import { gqlClent } from "../../client/gqlClient";

export const insertUserMutation = async (user: any) => {
  await gqlClent.mutate({
    variables: {
      id: user.uid,
      email: user.email,
      displayName: user.displayName || "",
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL
    },
    mutation: gql`
      mutation InserUser(
        $id: String!
        $email: String!
        $displayName: String
        $phoneNumber: String
        $photoURL: String
      ) {
        insert_myusers(
          objects: {
            email: $email
            displayName: $displayName
            id: $id
            phoneNumber: $phoneNumber
            photoURL: $photoURL
          }
        ) {
          returning {
            id
            displayName
            email
            phoneNumber
            photoURL
          }
        }
      }
    `
  });
};

export const updateUserMutation = async (user: any) => {
  await gqlClent.mutate({
    variables: {
      id: user.uid,
      email: user.email,
      displayName: user.displayName || "",
      phoneNumber: user.phoneNumber,
      photoURL: user.photoURL
    },
    mutation: gql`
      mutation UpdateUser(
        $id: String!
        $email: String
        $displayName: String
        $phoneNumber: String
        $photoURL: String
      ) {
        update_myusers(
          where: { id: { _eq: $id } }
          _set: {
            displayName: $displayName
            email: $email
            photoURL: $photoURL
            phoneNumber: $phoneNumber
          }
        ) {
          returning {
            displayName
            email
            id
            phoneNumber
            photoURL
          }
        }
      }
    `
  });
};
