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
    projectId: 'demo-user',
    firestore: {
      rules: fs.readFileSync('./firestore.rules', 'utf8')
    }
  })
})
beforeEach(async () => await testEnv.clearFirestore())
afterAll(async () => await testEnv.cleanup())

// users/userId
describe('【users/userId】', () => {

    // create
    describe('【create】', () => {
      describe('OK', () => {
        test('認証済み, userId同じ, createdAtあり, emailあり', async () => {
          await assertSucceeds(
            testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).set({
              createdAt: serverTimestamp(),
              email: 'test@gmail.com'
            })
          )
        })
      })
  
      describe('NG', () => {
        test('未認証', async () => {
          await assertFails(
            testEnv.unauthenticatedContext().firestore().doc(`users/${userId}`).set({
              createdAt: serverTimestamp(),
              email: 'test@gmail.com'
            })
          )
        })
        test('userId異なる', async () => {
          await assertFails(
            testEnv.authenticatedContext(userId).firestore().doc(`users/wrongUser`).set({
              createdAt: serverTimestamp(),
              email: 'test@gmail.com'
            })
          )
        })
        test('createdAtなし', async () => {
          await assertFails(
            testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).set({
              email: 'test@gmail.com'
            })
          )
        })
        test('emailなし', async () => {
          await assertFails(
            testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).set({
              createdAt: serverTimestamp(),
            })
          )
        })
        test('test(想定外のフィールド)あり', async () => {
          await assertFails(
            testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).set({
              createdAt: serverTimestamp(),
              email: 'test@gmail.com',
              test: 'test',
            })
          )
        })
        test('createdAtの型がstring', async () => {
          await assertFails(
            testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).set({
              createdAt: 'string',
              email: 'test@gmail.com'
            })
          )
        })
      })
    })
  
    // update
    describe('【update】', () => {
      test('認証済み, userId同じ, createdAtあり, emailあり', async () => {
        await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).set({
          createdAt: serverTimestamp(),
          email: 'test@gmail.com'
        })
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).update({
            createdAt: serverTimestamp(),
            email: 'test@gmail.com'
          })
        )
      })
    })
  
    // read
    describe('【read】', () => {
      describe('NG', () => {
        test('認証済み, userId同じ, document', async () => {
          await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).set({
            createdAt: serverTimestamp(),
            email: 'test@gmail.com'
          })
          await assertFails(
            testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).get()
          )
        })
        test('認証済み, userId同じ, collection', async () => {
          await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).set({
            createdAt: serverTimestamp(),
            email: 'test@gmail.com'
          })
          await assertFails(
            testEnv.authenticatedContext(userId).firestore().collection(`users`).get()
          )
        })
      })
    })
  
    // delete
    describe('【delete】', () => {
      describe('OK', () => {
        test('認証済み, userId同じ', async () => {
          await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).set({
            createdAt: serverTimestamp(),
            email: 'test@gmail.com'
          })
          await assertSucceeds(
            testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).delete()
          )
        })
      })
  
      describe('NG', () => {
        test('未認証', async () => {
          await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).set({
            createdAt: serverTimestamp(),
            email: 'test@gmail.com'
          })
          await assertFails(
            testEnv.unauthenticatedContext().firestore().doc(`users/${userId}`).delete()
          )
        })
        test('認証済み, userId異なる', async () => {
          await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}`).set({
            createdAt: serverTimestamp(),
            email: 'test@gmail.com'
          })
          await assertFails(
            testEnv.authenticatedContext(userId).firestore().doc(`users/$wrongUser`).delete()
          )
        })
      })
    })
  })