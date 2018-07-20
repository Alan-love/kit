module Kit.Compiler.UnifySpec where

import Test.Hspec
import Test.QuickCheck
import Kit.Ast
import Kit.Compiler
import Kit.Parser
import Kit.Str

testUnify ctx a b c = do
  tctx <- newTypeContext []
  mod <- newMod [] ""
  unification <- unify ctx tctx mod a b
  unification `shouldBe` c

spec :: Spec
spec = do
  describe "TypeSpec unification" $ do
    it "unifies type variables" $ do
      ctx <- newCompileContext
      a <- makeTypeVar ctx null_span
      b <- makeTypeVar ctx null_span
      testUnify ctx
        a
        b
        (TypeVarIs (TypeVar 1) b)
      testUnify ctx
        a
        (TypeStruct (["a", "b"], "mytype") [])
        (TypeVarIs (TypeVar 1) (TypeStruct (["a", "b"], "mytype") []))
      testUnify ctx
        (TypeStruct (["a", "b"], "mytype") [])
        a
        (TypeVarIs (TypeVar 1) (TypeStruct (["a", "b"], "mytype") []))
  describe "Basic type unifiation" $ do
    it "unifies numeric types" $ do
      unifyBasic (BasicTypeInt 32) (BasicTypeInt 64)
        `shouldBe` TypeConstraintSatisfied
      unifyBasic (BasicTypeInt 64) (BasicTypeInt 32)
        `shouldBe` TypeConstraintSatisfied
      unifyBasic (BasicTypeInt 32) (BasicTypeUint 64)
        `shouldBe` TypeConstraintSatisfied
      unifyBasic (BasicTypeUint 32) (BasicTypeUint 64)
        `shouldBe` TypeConstraintSatisfied
      unifyBasic (BasicTypeUint 32) (BasicTypeFloat 64)
        `shouldBe` TypeConstraintSatisfied
      unifyBasic (BasicTypeInt 32) (BasicTypeFloat 64)
        `shouldBe` TypeConstraintSatisfied
      unifyBasic (BasicTypeFloat 32) (BasicTypeUint 64)
        `shouldBe` TypeConstraintNotSatisfied