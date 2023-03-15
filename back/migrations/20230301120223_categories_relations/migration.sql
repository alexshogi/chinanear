/*
  Warnings:

  - You are about to drop the `_SubCategory_parent` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `_SubSubCategory_parent` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropIndex
DROP INDEX "_SubCategory_parent_B_index";

-- DropIndex
DROP INDEX "_SubCategory_parent_AB_unique";

-- DropIndex
DROP INDEX "_SubSubCategory_parent_B_index";

-- DropIndex
DROP INDEX "_SubSubCategory_parent_AB_unique";

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "_SubCategory_parent";
PRAGMA foreign_keys=on;

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "_SubSubCategory_parent";
PRAGMA foreign_keys=on;

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_SubSubCategory" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "code" TEXT NOT NULL DEFAULT '',
    "titleRu" TEXT NOT NULL DEFAULT '',
    "titleEn" TEXT NOT NULL DEFAULT '',
    "titleCh" TEXT NOT NULL DEFAULT '',
    "parent" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "SubSubCategory_parent_fkey" FOREIGN KEY ("parent") REFERENCES "SubCategory" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_SubSubCategory" ("code", "createdAt", "id", "isActive", "titleCh", "titleEn", "titleRu", "updatedAt") SELECT "code", "createdAt", "id", "isActive", "titleCh", "titleEn", "titleRu", "updatedAt" FROM "SubSubCategory";
DROP TABLE "SubSubCategory";
ALTER TABLE "new_SubSubCategory" RENAME TO "SubSubCategory";
CREATE INDEX "SubSubCategory_parent_idx" ON "SubSubCategory"("parent");
CREATE TABLE "new_SubCategory" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "code" TEXT NOT NULL DEFAULT '',
    "titleRu" TEXT NOT NULL DEFAULT '',
    "titleEn" TEXT NOT NULL DEFAULT '',
    "titleCh" TEXT NOT NULL DEFAULT '',
    "parent" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT "SubCategory_parent_fkey" FOREIGN KEY ("parent") REFERENCES "Category" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_SubCategory" ("code", "createdAt", "id", "isActive", "titleCh", "titleEn", "titleRu", "updatedAt") SELECT "code", "createdAt", "id", "isActive", "titleCh", "titleEn", "titleRu", "updatedAt" FROM "SubCategory";
DROP TABLE "SubCategory";
ALTER TABLE "new_SubCategory" RENAME TO "SubCategory";
CREATE INDEX "SubCategory_parent_idx" ON "SubCategory"("parent");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
