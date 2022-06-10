import { describe, test, jest, beforeAll, beforeEach, afterAll } from "@jest/globals";
import * as ftest from '@firebase/rules-unit-testing'
import { assertFails, assertSucceeds } from '@firebase/rules-unit-testing'
import * as fs from 'fs'

import { serverTimestamp as st} from 'firebase/firestore'
const serverTimestamp = () => st()

let testEnv: ftest.RulesTestEnvironment
const userId = 'user'
const itemId = 'item'

jest.setTimeout(20000);

beforeAll(async () => {
  testEnv = await ftest.initializeTestEnvironment({
    projectId: 'demo-other-cart-item',
    firestore: {
      rules: fs.readFileSync('./firestore.rules', 'utf8')
    }
  })
})
beforeEach(async () => await testEnv.clearFirestore())
afterAll(async () => await testEnv.cleanup())

// users/userId/otherCartItems/itemId
describe('【users/userId/otherCartItems/itemId】', () => {

  // create
  describe('【create】', () => {
    describe('OK', () => {
      test('認証済み, userId同じ, 全フィールドあり(入力値：最大)', async () => {
        await assertSucceeds(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/otherCartItems/${itemId}`).set({
            createdAt: serverTimestamp(),
            title: '12345678901234567890',
            subTitle: '12345678901234567890',
          })
        )
      })
      test('認証済み, userId同じ, 全フィールドあり(入力値：最小)', async () => {
        await assertSucceeds(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/otherCartItems/${itemId}`).set({
            createdAt: serverTimestamp(),
            title: '1',
            subTitle: '',
          })
        )
      })
    })

    describe('NG', () => {
      test('未認証', async () => {
        await assertFails(
          testEnv.unauthenticatedContext().firestore().doc(`users/${userId}/otherCartItems/${itemId}`).set({
            createdAt: serverTimestamp(),
            title: '12345678901234567890',
            subTitle: '12345678901234567890',
          })
        )
      })
      test('userId異なる', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/wrongUser/otherCartItems/${itemId}`).set({
            createdAt: serverTimestamp(),
            title: '12345678901234567890',
            subTitle: '12345678901234567890',
          })
        )
      })
      test('createdAtなし', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/otherCartItems/${itemId}`).set({
            title: '12345678901234567890',
            subTitle: '12345678901234567890',
          })
        )
      })
      test('titleなし', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/otherCartItems/${itemId}`).set({
            createdAt: serverTimestamp(),
            subTitle: '12345678901234567890',
          })
        )
      })
      test('subTitleが21文字', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/otherCartItems/${itemId}`).set({
            createdAt: serverTimestamp(),
            title: '123456789012345678901',
            subTitle: '12345678901234567890',
          })
        )
      })
      test('createdAtの型がstring', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/otherCartItems/${itemId}`).set({
            createdAt: 'a',
            title: '12345678901234567890',
            subTitle: '12345678901234567890',
          })
        )
      })
      test('test(想定外のフィールド)あり', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/otherCartItems/${itemId}`).set({
            createdAt: 'a',
            title: '12345678901234567890',
            subTitle: '12345678901234567890',
            test: 'test',
          })
        )
      })
    })
  })

//   // update
//   describe('【update】', () => {
//     test('認証済み, userId同じ, deletedAtあり', async () => {
//       await testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).set({
//         deletedAt: serverTimestamp()
//       })
//       await assertFails(
//         testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).update({
//           deletedAt: serverTimestamp()
//         })
//       )
//     })
//   })

//   // read
//   describe('【read】', () => {
//     describe('OK', () => {
//       test('認証済み, userId同じ, document', async () => {
//         await testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).set({
//           deletedAt: serverTimestamp()
//         })
//         await assertFails(
//           testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).get()
//         )
//       })
//       test('認証済み, userId同じ, collection', async () => {
//         await testEnv.authenticatedContext(userId).firestore().doc(`deletedUsers/${userId}`).set({
//           deletedAt: serverTimestamp()
//         })
//         await assertFails(
//           testEnv.authenticatedContext(userId).firestore().collection(`deletedUsers`).get()
//         )
//       })
//     })
//   })

  // delete
  describe('【delete】', () => {
    describe('OK', () => {
      test('認証済み, userId同じ', async () => {
        await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/otherCartItems/${itemId}`).set({
            createdAt: serverTimestamp(),
            title: '12345678901234567890',
            subTitle: '12345678901234567890',
          })
        await assertSucceeds(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/otherCartItems/${itemId}`).delete()
        )
      })
    })

    describe('NG', () => {
        test('未認証', async () => {
          await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/otherCartItems/${itemId}`).set({
              createdAt: serverTimestamp(),
              title: '12345678901234567890',
              subTitle: '12345678901234567890',
            })
          await assertFails(
            testEnv.unauthenticatedContext().firestore().doc(`users/${userId}/otherCartItems/${itemId}`).delete()
          )
        })
        test('userId違う', async () => {
            await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/otherCartItems/${itemId}`).set({
                createdAt: serverTimestamp(),
                title: '12345678901234567890',
                subTitle: '12345678901234567890',
              })
            await assertFails(
              testEnv.authenticatedContext(userId).firestore().doc(`users/wrongUser/otherCartItems/${itemId}`).delete()
            )
          })
      })
  })
})