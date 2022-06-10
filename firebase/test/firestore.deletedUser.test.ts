import { describe, test, jest, beforeAll, beforeEach, afterAll } from "@jest/globals";
import * as ftest from '@firebase/rules-unit-testing'
import { assertFails, assertSucceeds } from '@firebase/rules-unit-testing'
import * as fs from 'fs'

import { serverTimestamp as st} from 'firebase/firestore'
const serverTimestamp = () => st()

let testEnv: ftest.RulesTestEnvironment
const userId = 'user'

jest.setTimeout(20000);

beforeAll(async () => {
  testEnv = await ftest.initializeTestEnvironment({
    projectId: 'demo-deleted-user',
    firestore: {
      rules: fs.readFileSync('./firestore.rules', 'utf8')
    }
  })
})
beforeEach(async () => await testEnv.clearFirestore())
afterAll(async () => await testEnv.cleanup())

// deletedUsers/userId
describe('【deletedUsers/userId】', () => {

  // create
  describe('【create】', () => {
    describe('OK', () => {
      test('認証済み, userId同じ, deletedAtあり', async () => {
        await assertSucceeds(
          testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).set({
            deletedAt: serverTimestamp(),
          })
        )
      })
    })

    describe('NG', () => {
      test('未認証', async () => {
        await assertFails(
          testEnv.unauthenticatedContext().firestore().doc(`deletedUsers/${userId}`).set({
            deletedAt: serverTimestamp()
          })
        )
      })
      test('userId異なる', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/wrongUser`).set({
            createdAt: serverTimestamp()
          })
        )
      })
      test('deletedAtなし', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).set({

          })
        )
      })
      test('deletedAtなし, email(想定外のフィールド)あり', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).set({
            email: 'test@gmail.com'
          })
        )
      })
      test('deletedAtの型がstring', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).set({
            deletedAt: 'string'
          })
        )
      })
    })
  })

  // update
  describe('【update】', () => {
    test('認証済み, userId同じ, deletedAtあり', async () => {
      await testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).set({
        deletedAt: serverTimestamp()
      })
      await assertFails(
        testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).update({
          deletedAt: serverTimestamp()
        })
      )
    })
  })

  // read
  describe('【read】', () => {
    describe('NG', () => {
      test('認証済み, userId同じ, document', async () => {
        await testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).set({
          deletedAt: serverTimestamp()
        })
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).get()
        )
      })
      test('認証済み, userId同じ, collection', async () => {
        await testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).set({
          deletedAt: serverTimestamp()
        })
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().collection(`deletedUsers`).get()
        )
      })
    })
  })

  // delete
  describe('【delete】', () => {
    describe('OK', () => {
      test('認証済み, userId同じ', async () => {
        await testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).set({
          deletedAt: serverTimestamp()
        })
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).delete()
        )
      })
    })
  })
})