import { describe, test, jest, beforeAll, beforeEach, afterAll } from "@jest/globals";
import * as ftest from '@firebase/rules-unit-testing'
import { assertFails, assertSucceeds } from '@firebase/rules-unit-testing'
import * as fs from 'fs'

import { serverTimestamp as st} from 'firebase/firestore'
const serverTimestamp = () => st()

let testEnv: ftest.RulesTestEnvironment
const userId = 'user'
const recipeId = 'recipe'

jest.setTimeout(20000);

beforeAll(async () => {
  testEnv = await ftest.initializeTestEnvironment({
    projectId: 'demo-recipe-app-74426',
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
    describe('未認証のユーザー', () => {
      test('NG', async () => {
        await assertFails(
          testEnv.unauthenticatedContext().firestore().doc('users/&{userId}').set({
            createdAt: serverTimestamp(),
            email: 'test@gmail.com'
          })
        )
      })
    })

  describe('認証済みのユーザー', () => {
    describe('userId同じ', () => {
      test('OK', async () => {
        await assertSucceeds(
          testEnv.authenticatedContext(userId).firestore().doc('users/&{userId}').set({
            createdAt: serverTimestamp(),
            email: 'test@gmail.com'
          })
        )
      })
    })
    describe("userId違う", () => {
      test('NG', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc('users/wrongUser').set({
            createdAt: serverTimestamp(),
            email: 'test@gmail.com'
          })
        )
      })
    })
  })
  })
})
