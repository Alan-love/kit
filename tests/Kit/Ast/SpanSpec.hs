module Kit.Ast.SpanSpec where

import Test.Hspec
import Kit.Parser

spec :: Spec
spec = do
  describe "Span merging" $ do
    it "merges spans" $ do
      (sp "" 2 1 3 5) <+> (sp "" 2 1 3 5) `shouldBe` (sp "" 2 1 3 5)
      (sp "" 1 1 1 1) <+> (sp "" 1 2 1 3) `shouldBe` (sp "" 1 1 1 3)
      (sp "" 1 1 2 3) <+> (sp "" 2 1 2 4) `shouldBe` (sp "" 1 1 2 4)
      (sp "" 1 2 1 3) <+> (sp "" 1 1 1 1) `shouldBe` (sp "" 1 1 1 3)
      (sp "" 1 1 2 1) <+> (sp "" 1 3 1 4) `shouldBe` (sp "" 1 1 2 1)
      (sp "" 1 1 1 5) <+> (sp "" 3 1 3 5) `shouldBe` (sp "" 1 1 3 5)
      (sp "" 1 5 1 7) <+> (sp "" 1 2 1 3) `shouldBe` (sp "" 1 2 1 7)
      (sp "" 7 5 7 10) <+> (sp "" 6 1 7 6) `shouldBe` (sp "" 6 1 7 10)
      (NoPos) <+> (sp "" 1 2 3 4) `shouldBe` (sp "" 1 2 3 4)
      (sp "" 1 2 3 4) <+> (NoPos) `shouldBe` (sp "" 1 2 3 4)
      (NoPos) <+> (NoPos) `shouldBe` NoPos

    it "maintains span file info when merging" $ do
      (sp "abc" 2 1 3 5) <+> (sp "abc" 2 1 3 5) `shouldBe` (sp "abc" 2 1 3 5)
