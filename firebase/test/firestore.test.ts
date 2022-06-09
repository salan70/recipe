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

// users/userId/recipes/recipeId
describe('【users/userId/recipes/recipeId】', () => {

  // create
  describe('【create】', () => {
    describe('OK', () => {
      test('認証済み, userId同じ, 全フィールドあり(入力値：最小)', async () => {
        await assertSucceeds(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
            recipeName: 'a',
            recipeGrade: 0.5,
            forHowManyPeople: 1,
            recipeMemo: null,
            imageUrl: '',
            ingredientList: {},
            procedureList: {},
            createdAt: serverTimestamp(),
            countInCart: 0,
          })
        )
      })
      test('認証済み, userId同じ, 全フィールドあり(入力値：最大)', async () => {
        await assertSucceeds(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
            recipeName: "123456789012345678901234567890",
            recipeGrade: 5,
            forHowManyPeople: 99,
            recipeMemo: "500文字:78901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
            imageUrl: "1000文字:890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
            ingredientList: {
              0: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              1: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              2: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              3: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              4: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              5: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              6: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              7: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              8: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              9: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              10: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              11: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              12: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              13: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              14: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              15: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              16: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              17: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              18: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              19: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              20: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              21: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              22: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              23: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              24: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              25: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              26: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              27: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              28: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              29: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
            },
            procedureList: {
              0 : "procedure",
              1 : "procedure",
              2 : "procedure",
              3 : "procedure",
              4 : "procedure",
              5 : "procedure",
              6 : "procedure",
              7 : "procedure",
              8 : "procedure",
              9 : "procedure",
              10 : "procedure",
              11 : "procedure",
              12 : "procedure",
              13 : "procedure",
              14 : "procedure",
              15 : "procedure",
              16 : "procedure",
              17 : "procedure",
              18 : "procedure",
              19 : "procedure",
              20 : "procedure",
              21 : "procedure",
              22 : "procedure",
              23 : "procedure",
              24 : "procedure",
              25 : "procedure",
              26 : "procedure",
              27 : "procedure",
              28 : "procedure",
              29 : "procedure",
            },
            createdAt: serverTimestamp(),
            countInCart: 0,
          })
        )
      })
    })

    describe('NG', () => {
      test('未認証', async () => {
        await assertFails(
          testEnv.unauthenticatedContext().firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
            recipeName: 'a',
            recipeGrade: 0.5,
            forHowManyPeople: 1,
            recipeMemo: null,
            imageUrl: '',
            ingredientList: {},
            procedureList: {},
            createdAt: serverTimestamp(),
            countInCart: 0,
          })
        )
      })
      test('userId異なる', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/wrongUser/recipes/${recipeId}`).set({
            recipeName: 'a',
            recipeGrade: 0.5,
            forHowManyPeople: 1,
            recipeMemo: null,
            imageUrl: '',
            ingredientList: {},
            procedureList: {},
            createdAt: serverTimestamp(),
            countInCart: 0,
          })
        )
      })
      test('test(想定外のフィールド)あり', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
            recipeName: 'a',
            recipeGrade: 0.5,
            forHowManyPeople: 1,
            recipeMemo: null,
            imageUrl: '',
            ingredientList: {},
            procedureList: {},
            createdAt: serverTimestamp(),
            countInCart: 0,
            test: 'test',
          })
        )
      })
      test('recipeNameの型が違う', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
            recipeName: serverTimestamp(),
            recipeGrade: 0.5,
            forHowManyPeople: 1,
            recipeMemo: null,
            imageUrl: '',
            ingredientList: {},
            procedureList: {},
            createdAt: serverTimestamp(),
            countInCart: 0,
          })
        )
      })
      test('recipeNameなし', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
            recipeGrade: 0.5,
            forHowManyPeople: 1,
            recipeMemo: null,
            imageUrl: '',
            ingredientList: {},
            procedureList: {},
            createdAt: serverTimestamp(),
            countInCart: 0,
          })
        )
      })
      test('recipeNameが0文字', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
            recipeName: '',
            recipeGrade: 0.5,
            forHowManyPeople: 1,
            recipeMemo: null,
            imageUrl: '',
            ingredientList: {},
            procedureList: {},
            createdAt: serverTimestamp(),
            countInCart: 0,
          })
        )
      })
      test('ingredientListのsize()が31', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
            recipeName: ' ',
            recipeGrade: 0.5,
            forHowManyPeople: 1,
            recipeMemo: null,
            imageUrl: '',
            ingredientList: {
              0: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              1: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              2: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              3: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              4: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              5: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              6: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              7: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              8: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              9: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              10: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              11: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              12: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              13: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              14: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              15: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              16: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              17: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              18: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              19: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              20: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              21: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              22: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              23: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              24: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              25: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
              26: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
              27: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              28: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
              29: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
              30: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
            },
            procedureList: {},
            createdAt: serverTimestamp(),
            countInCart: 0,
          })
        )
      })
      test('recipeNameが31文字', async () => {
        await assertFails(
          testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
            recipeName: '1234567890123456789012345678901',
            recipeGrade: 0.5,
            forHowManyPeople: 1,
            recipeMemo: null,
            imageUrl: '',
            ingredientList: {},
            procedureList: {},
            createdAt: serverTimestamp(),
            countInCart: 0,
          })
        )
      })

      // update
      describe('【update】', () => {
        describe('OK', () => {
          test('認証済み, userId同じ, 全フィールドあり(入力値：最小)', async () => {
            await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
              recipeName: 'a',
              recipeGrade: 0.5,
              forHowManyPeople: 1,
              recipeMemo: null,
              imageUrl: '',
              ingredientList: {},
              procedureList: {},
              createdAt: serverTimestamp(),
              countInCart: 0,
            })
            await assertSucceeds(
              testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).update({
                recipeName: 'b',
                recipeGrade: 0.5,
                forHowManyPeople: 1,
                recipeMemo: null,
                imageUrl: '',
                ingredientList: {},
                procedureList: {},
              })
            )
          })
          test('認証済み, userId同じ, 全フィールドあり(入力値：最大)', async () => {
            await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
              recipeName: 'a',
              recipeGrade: 0.5,
              forHowManyPeople: 1,
              recipeMemo: null,
              imageUrl: '',
              ingredientList: {},
              procedureList: {},
              createdAt: serverTimestamp(),
              countInCart: 0,
            })
            await assertSucceeds(
              testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).update({
                recipeName: "123456789012345678901234567890",
                recipeGrade: 5,
                forHowManyPeople: 99,
                recipeMemo: "500文字:78901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
                imageUrl: "1000文字:890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
                ingredientList: {
                  0: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
                  1: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
                  2: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
                  3: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
                  4: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
                  5: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
                  6: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
                  7: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
                  8: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
                  9: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
                  10: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
                  11: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
                  12: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
                  13: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
                  14: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
                  15: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
                  16: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
                  17: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
                  18: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
                  19: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
                  20: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
                  21: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
                  22: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
                  23: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
                  24: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
                  25: {ingredientName: "じゃがいも", ingredientAmount: "2", ingredientUnit: "個"},
                  26: {ingredientName: "にんじん", ingredientAmount: "2", ingredientUnit: "個"},
                  27: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
                  28: {ingredientName: "さつまいも", ingredientAmount: "2", ingredientUnit: "個"},
                  29: {ingredientName: "さといも", ingredientAmount: "2", ingredientUnit: "個"},
                },
                procedureList: {
                  0 : "procedure",
                  1 : "procedure",
                  2 : "procedure",
                  3 : "procedure",
                  4 : "procedure",
                  5 : "procedure",
                  6 : "procedure",
                  7 : "procedure",
                  8 : "procedure",
                  9 : "procedure",
                  10 : "procedure",
                  11 : "procedure",
                  12 : "procedure",
                  13 : "procedure",
                  14 : "procedure",
                  15 : "procedure",
                  16 : "procedure",
                  17 : "procedure",
                  18 : "procedure",
                  19 : "procedure",
                  20 : "procedure",
                  21 : "procedure",
                  22 : "procedure",
                  23 : "procedure",
                  24 : "procedure",
                  25 : "procedure",
                  26 : "procedure",
                  27 : "procedure",
                  28 : "procedure",
                  29 : "procedure",
                },
              })
            )
          })
          test('認証済み, userId同じ, imageUrlあり(最大文字) (レシピ更新時にimageも更新した際のテスト)', async () => {
            await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
              recipeName: 'a',
              recipeGrade: 0.5,
              forHowManyPeople: 1,
              recipeMemo: null,
              imageUrl: '',
              ingredientList: {},
              procedureList: {},
              createdAt: serverTimestamp(),
              countInCart: 0,
            })
            await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).update({
                recipeName: 'b',
                recipeGrade: 0.5,
                forHowManyPeople: 1,
                recipeMemo: null,
                imageUrl: '',
                ingredientList: {},
                procedureList: {},
            })
            await assertSucceeds(
              testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).update({
                imageUrl: "1000文字:890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890",
              })
            )
          })
          test('認証済み, userId同じ, countInCartあり(最大値) (countInCartを更新した際のテスト)', async () => {
            await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
              recipeName: 'a',
              recipeGrade: 0.5,
              forHowManyPeople: 1,
              recipeMemo: null,
              imageUrl: '',
              ingredientList: {},
              procedureList: {},
              createdAt: serverTimestamp(),
              countInCart: 0,
            })
            await assertSucceeds(
              testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).update({
                countInCart: 99
              })
            )
          })

          describe('NG', () => {
            test('未認証', async () => {
              await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                recipeName: 'a',
                recipeGrade: 0.5,
                forHowManyPeople: 1,
                recipeMemo: null,
                imageUrl: '',
                ingredientList: {},
                procedureList: {},
                createdAt: serverTimestamp(),
                countInCart: 0,
              })
              await assertFails(
                testEnv.unauthenticatedContext().firestore().doc(`users/${userId}/recipes/${recipeId}`).update({
                  recipeName: 'b',
                  recipeGrade: 0.5,
                  forHowManyPeople: 1,
                  recipeMemo: null,
                  imageUrl: '',
                  ingredientList: {},
                  procedureList: {},
                })
              )
            })
            test('userId違う', async () => {
              await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                recipeName: 'a',
                recipeGrade: 0.5,
                forHowManyPeople: 1,
                recipeMemo: null,
                imageUrl: '',
                ingredientList: {},
                procedureList: {},
                createdAt: serverTimestamp(),
                countInCart: 0,
              })
              await assertFails(
                testEnv.unauthenticatedContext().firestore().doc(`users/wrongUser/recipes/${recipeId}`).update({
                  recipeName: 'b',
                  recipeGrade: 0.5,
                  forHowManyPeople: 1,
                  recipeMemo: null,
                  imageUrl: '',
                  ingredientList: {},
                  procedureList: {},
                })
              )
            })
            test('imageUrl 1001文字', async () => {
              await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                recipeName: 'a',
                recipeGrade: 0.5,
                forHowManyPeople: 1,
                recipeMemo: null,
                imageUrl: '',
                ingredientList: {},
                procedureList: {},
                createdAt: serverTimestamp(),
                countInCart: 0,
              })
              await assertFails(
                testEnv.unauthenticatedContext().firestore().doc(`users/wrongUser/recipes/${recipeId}`).update({
                  imageUrl: "1001文字:8901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901",
                })
              )
            })
            test('countInCart 100', async () => {
              await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                recipeName: 'a',
                recipeGrade: 0.5,
                forHowManyPeople: 1,
                recipeMemo: null,
                imageUrl: '',
                ingredientList: {},
                procedureList: {},
                createdAt: serverTimestamp(),
                countInCart: 0,
              })
              await assertFails(
                testEnv.unauthenticatedContext().firestore().doc(`users/wrongUser/recipes/${recipeId}`).update({
                  countInCart: 100
                })
              )
            })
            test('countInCartとimageUrlあり', async () => {
              await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                recipeName: 'a',
                recipeGrade: 0.5,
                forHowManyPeople: 1,
                recipeMemo: null,
                imageUrl: '',
                ingredientList: {},
                procedureList: {},
                createdAt: serverTimestamp(),
                countInCart: 0,
              })
              await assertFails(
                testEnv.unauthenticatedContext().firestore().doc(`users/wrongUser/recipes/${recipeId}`).update({
                  ImageUrl: 'test.jpg',
                  countInCart: 100
                })
              )
            })
            test('test(想定外のフィールド)あり', async () => {
              await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                recipeName: 'a',
                recipeGrade: 0.5,
                forHowManyPeople: 1,
                recipeMemo: null,
                imageUrl: '',
                ingredientList: {},
                procedureList: {},
                createdAt: serverTimestamp(),
                countInCart: 0,
              })
              await assertFails(
                testEnv.unauthenticatedContext().firestore().doc(`users/wrongUser/recipes/${recipeId}`).update({
                  recipeName: 'a',
                  recipeGrade: 0.5,
                  forHowManyPeople: 1,
                  recipeMemo: null,
                  imageUrl: '',
                  ingredientList: {},
                  procedureList: {},
                  test: 'test',
                })
              )
            })
          })

          // read
          describe('【read】', () => {
            describe('OK', () => {
              test('認証済み, userId同じ, document', async () => {
                await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                  recipeName: 'a',
                  recipeGrade: 0.5,
                  forHowManyPeople: 1,
                  recipeMemo: null,
                  imageUrl: '',
                  ingredientList: {},
                  procedureList: {},
                  createdAt: serverTimestamp(),
                  countInCart: 0,
                })
                await assertSucceeds(
                  testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).get()
                )
              })
              test('認証済み, userId同じ, collection', async () => {
                await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                  recipeName: 'a',
                  recipeGrade: 0.5,
                  forHowManyPeople: 1,
                  recipeMemo: null,
                  imageUrl: '',
                  ingredientList: {},
                  procedureList: {},
                  createdAt: serverTimestamp(),
                  countInCart: 0,
                })
                await assertSucceeds(
                  testEnv.authenticatedContext(userId).firestore().collection(`users/${userId}/recipes`).get()
                )
              })
            })

            describe('NG', () => {
              test('未認証 document', async () => {
                await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                  recipeName: 'a',
                  recipeGrade: 0.5,
                  forHowManyPeople: 1,
                  recipeMemo: null,
                  imageUrl: '',
                  ingredientList: {},
                  procedureList: {},
                  createdAt: serverTimestamp(),
                  countInCart: 0,
                })
                await assertFails(
                  testEnv.unauthenticatedContext().firestore().doc(`users/${userId}/recipes/${recipeId}`).get()
                )
              })
              test('userId違う, collection', async () => {
                await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                  recipeName: 'a',
                  recipeGrade: 0.5,
                  forHowManyPeople: 1,
                  recipeMemo: null,
                  imageUrl: '',
                  ingredientList: {},
                  procedureList: {},
                  createdAt: serverTimestamp(),
                  countInCart: 0,
                })
                await assertFails(
                  testEnv.authenticatedContext(userId).firestore().collection(`users/wrongUser/recipes`).get()
                )
              })
            })
          })

          // delete
          describe('【delete】', () => {
            describe('OK', () => {
              test('認証済み, userId同じ', async () => {
                await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                  recipeName: 'a',
                  recipeGrade: 0.5,
                  forHowManyPeople: 1,
                  recipeMemo: null,
                  imageUrl: '',
                  ingredientList: {},
                  procedureList: {},
                  createdAt: serverTimestamp(),
                  countInCart: 0,
                })
                await assertSucceeds(
                  testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).delete()
                )
              })
            })

            describe('NG', () => {
              test('未認証', async () => {
                await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                  recipeName: 'a',
                  recipeGrade: 0.5,
                  forHowManyPeople: 1,
                  recipeMemo: null,
                  imageUrl: '',
                  ingredientList: {},
                  procedureList: {},
                  createdAt: serverTimestamp(),
                  countInCart: 0,
                })
                await assertFails(
                  testEnv.unauthenticatedContext().firestore().doc(`users/${userId}/recipes/${recipeId}`).delete()
                )
              })
              test('userId違う', async () => {
                await testEnv.authenticatedContext(userId).firestore().doc(`users/${userId}/recipes/${recipeId}`).set({
                  recipeName: 'a',
                  recipeGrade: 0.5,
                  forHowManyPeople: 1,
                  recipeMemo: null,
                  imageUrl: '',
                  ingredientList: {},
                  procedureList: {},
                  createdAt: serverTimestamp(),
                  countInCart: 0,
                })
                await assertFails(
                  testEnv.authenticatedContext(userId).firestore().doc(`users/wrongUser/recipes/${recipeId}`).delete()
                )
              })
            })
          })
        })
      })
    })
  })
})