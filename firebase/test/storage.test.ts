import { describe, test, jest, beforeAll, beforeEach, afterAll } from "@jest/globals";
import * as ftest from '@firebase/rules-unit-testing'
import { assertFails, assertSucceeds } from '@firebase/rules-unit-testing'
import firebaseApp from 'firebase/compat'
import * as fs from 'fs'
import 'jest'
type Storage = firebaseApp.storage.Storage

let testEnv: ftest.RulesTestEnvironment
const recipeImageRef = (storage: Storage, userId: string, recipeId: string, imageName: string) =>
  recipeImagesRef(storage, userId, recipeId).child(imageName)
const recipeImagesRef = (storage: Storage, userId: string, recipeId: string) =>
  storage.ref(`users/${userId}/recipeImages/${recipeId}`)
const loadIconImage = () => fs.readFileSync('./test.jpeg')
const contentType = 'image/jpeg'
const userId = 'user'
const recipeId = 'recipe'

jest.setTimeout(20000);

beforeAll(async () => {
  testEnv = await ftest.initializeTestEnvironment({
    projectId: 'demo-recipe-app-74426',
    storage: {
      rules: fs.readFileSync('./storage.rules', 'utf8'),
    },
  })
})
beforeEach(async () => await testEnv.clearStorage())
afterAll(async () => await testEnv.cleanup())

// get
describe('【get】', () => {
    describe('ALL NG: 未認証のユーザー', () => {
      beforeEach(async () => {
        await testEnv.withSecurityRulesDisabled(async context => {
          await recipeImageRef(context.storage(), userId, recipeId, 'test.jpeg').put(loadIconImage(), { contentType }).then()
        })
      })
      test('NG', async () => {
        await assertFails(
          recipeImageRef(testEnv.unauthenticatedContext().storage(), userId, recipeId, 'test.jpeg').getDownloadURL()
        )
      })
    })

  describe('OK or NG: 認証済みのユーザー', () => {
    beforeEach(async () => {
      await testEnv.withSecurityRulesDisabled(async context => {
        await recipeImageRef(context.storage(), userId, recipeId, 'test.jpeg').put(loadIconImage())
      })
    })
    describe('userId同じ', () => {
      test('OK', async () => {
        await assertSucceeds(recipeImageRef(testEnv.authenticatedContext(userId).storage(), userId, recipeId, 'test.jpeg').getDownloadURL())
      })
    })
    describe("userId違う", () => {
      test('NG', async () => {
        await assertFails(
          recipeImageRef(testEnv.authenticatedContext('wrongUser').storage(), userId, recipeId, 'test.jpeg').getDownloadURL()
        )
      })
    })
  })
})

// create
describe('【create】', () => {
      describe('ALL NG: 未認証のユーザー', () => {
        test('NG', async () => {
            await assertFails(
                recipeImageRef(
                  testEnv.unauthenticatedContext().storage(), userId, recipeId, 'test.jpeg')
                  .put(loadIconImage(), { contentType })
                  .then()
              )
        })
      })

    describe('OK or NG: 認証済みのユーザー', () => {
      describe('userId同じ', () => {
        test('OK', async () => {
          await assertSucceeds(recipeImageRef(
            testEnv.authenticatedContext(userId).storage(), userId, recipeId, 'test.jpeg')
            .put(loadIconImage(), { contentType })
            .then())
        })
      })
      describe("userId違う", () => {
        test('NG', async () => {
          await assertFails(
            recipeImageRef(
                testEnv.authenticatedContext(userId).storage(), 'wrongUser', recipeId, 'test.jpeg')
                .put(loadIconImage(), { contentType })
                .then()
          )
        })
      })
    })

    describe('OK or NG: ファイルサイズのバリデーション', () => {
      describe('OK: 19MiB', () => {
        const okSizeFile = () => fs.readFileSync('./19MiB.img')
        test('OK', async () => {
          await assertSucceeds(recipeImageRef(
            testEnv.authenticatedContext(userId).storage(), userId, recipeId, 'test.jpeg')
            .put(okSizeFile(), { contentType })
            .then())
        })
      })
      describe('NG: 20MiB', () => {
        const ngSizeFile = () => fs.readFileSync('./20MiB.img')
        test('NG', async () => {
          await assertFails(recipeImageRef(
            testEnv.authenticatedContext(userId).storage(), userId, recipeId, 'test.jpeg')
            .put(ngSizeFile(), { contentType })
            .then())
        })
      })
    })
  })

// delete
describe('【delete】', () => {
    describe('ALL NG: 未認証のユーザー', () => {
      beforeEach(async () => {
        await testEnv.withSecurityRulesDisabled(async context => {
          await recipeImageRef(context.storage(), userId, recipeId, 'test.jpeg').put(loadIconImage(), { contentType }).then()
        })
      })
      test('NG', async () => {
        await assertFails(
          recipeImageRef(testEnv.unauthenticatedContext().storage(), userId, recipeId, 'test.jpeg').delete()
        )
      })
    })

  describe('OK or NG: 認証済みのユーザー', () => {
    beforeEach(async () => {
      await testEnv.withSecurityRulesDisabled(async context => {
        await recipeImageRef(context.storage(), userId, recipeId, 'test.jpeg').put(loadIconImage())
      })
    })
    describe('userId同じ', () => {
      test('OK', async () => {
        await assertSucceeds(recipeImageRef(testEnv.authenticatedContext(userId).storage(), userId, recipeId, 'test.jpeg').delete())
      })
    })
    describe("userId違う", () => {
      test('NG', async () => {
        await assertFails(
          recipeImageRef(testEnv.authenticatedContext('wrongUser').storage(), userId, recipeId, 'test.jpeg').delete()
        )
      })
    })
  })
})