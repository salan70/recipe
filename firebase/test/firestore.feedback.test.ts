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
    projectId: 'demo-feedback',
    firestore: {
      rules: fs.readFileSync('./firestore.rules', 'utf8')
    }
  })
})
beforeEach(async () => await testEnv.clearFirestore())
afterAll(async () => await testEnv.cleanup())

// feedbacks
describe('【feedbacks/id】', () => {

  // create
  describe('【create】', () => {
    describe('OK', () => {
      test('認証済み, uidあり(userIdと同じ), feedbackあり(最大文字), createdAtあり', async () => {
        await assertSucceeds(testEnv.authenticatedContext(userId).firestore().collection(`feedbacks`).add({
          uid: userId,
          feedback: "500文字:78901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
          createdAt: serverTimestamp()}));
      })
    })

    describe('NG', () => {
      test('未認証', async () => {
        await assertFails(testEnv.unauthenticatedContext().firestore().collection(`feedbacks`).add({
          uid: userId,
          feedback: "500文字:78901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
          createdAt: serverTimestamp()}));
      })
      test('userId異なる', async () => {
        await assertFails(testEnv.authenticatedContext(userId).firestore().collection(`feedbacks`).add({
          uid: 'wrongUser',
          feedback: "500文字:78901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
          createdAt: serverTimestamp()}));
      })
      test('userIdなし', async () => {
        await assertFails(testEnv.authenticatedContext(userId).firestore().collection(`feedbacks`).add({
          feedback: "500文字:78901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
          createdAt: serverTimestamp()}));
      })
      test('feedbackなし', async () => {
        await assertFails(testEnv.authenticatedContext(userId).firestore().collection(`feedbacks`).add({
          uid: userId,
          createdAt: serverTimestamp()}));
      })
      test('feedback 501文字', async () => {
        await assertFails(testEnv.authenticatedContext(userId).firestore().collection(`feedbacks`).add({
          uid: 'wrongUser',
          feedback: "501文字:789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901",
          createdAt: serverTimestamp()}));
      })
      test('feedback 0文字', async () => {
        await assertFails(testEnv.authenticatedContext(userId).firestore().collection(`feedbacks`).add({
          uid: 'wrongUser',
          feedback: '',
          createdAt: serverTimestamp()}));
      })
    })
  })

  // update
  describe('【update】', () => {
    test('認証済み, uidあり(userIdと同じ), feedbackあり(最大文字), createdAtあり', async () => {
      const doc = await testEnv.authenticatedContext(userId).firestore().collection(`feedbacks`).add({
        uid: userId,
        feedback: 'test',
        createdAt: serverTimestamp()
      })
      await assertFails(
        doc.update({
          uid: 'wrongUser',
          feedback: 'test',
          createdAt: serverTimestamp()
        })
      )
    })
  })

  // read
  describe('【read】', () => {
    describe('NG', () => {
      test('認証済み, document', async () => {
        const doc = await testEnv.authenticatedContext(userId).firestore().collection(`feedbacks`).add({
          uid: userId,
          feedback: 'test',
          createdAt: serverTimestamp()
        })
        await assertFails(
          doc.get()
        )
      })
      test('認証済み, collection', async () => {
        const doc = await testEnv.authenticatedContext(userId).firestore().collection(`feedbacks`).add({
          uid: userId,
          feedback: 'test',
          createdAt: serverTimestamp()
        })
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().collection(`feedbacks`).get()
        )
      })
    })
  })

  // delete
  describe('【delete】', () => {
    describe('NG', () => {
      test('認証済み', async () => {
        const doc = await testEnv.authenticatedContext(userId).firestore().collection(`feedbacks`).add({
          uid: userId,
          feedback: 'test',
          createdAt: serverTimestamp()
        })
        await assertFails(
          doc.delete()
        )
      })
    })
  })
})