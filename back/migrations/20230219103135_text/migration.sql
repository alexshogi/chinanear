/*
  Warnings:

  - You are about to drop the column `caption` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the column `description` on the `Product` table. All the data in the column will be lost.
  - You are about to drop the column `title` on the `Product` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Product" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "titleRu" TEXT NOT NULL DEFAULT '',
    "titleEn" TEXT NOT NULL DEFAULT '',
    "titleCh" TEXT NOT NULL DEFAULT '',
    "captionRu" TEXT NOT NULL DEFAULT '',
    "captionEn" TEXT NOT NULL DEFAULT '',
    "captionCh" TEXT NOT NULL DEFAULT '',
    "descriptionRu" TEXT NOT NULL DEFAULT '',
    "descriptionEn" TEXT NOT NULL DEFAULT '',
    "descriptionCh" TEXT NOT NULL DEFAULT '',
    "balance" INTEGER,
    "category1" TEXT NOT NULL DEFAULT '',
    "category2" TEXT NOT NULL DEFAULT '',
    "category3" TEXT NOT NULL DEFAULT '',
    "intervals" TEXT,
    "isActive" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "image_filesize" INTEGER,
    "image_extension" TEXT,
    "image_width" INTEGER,
    "image_height" INTEGER,
    "image_id" TEXT,
    "author" TEXT,
    "seller" TEXT,
    CONSTRAINT "Product_author_fkey" FOREIGN KEY ("author") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Product_seller_fkey" FOREIGN KEY ("seller") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_Product" ("author", "balance", "captionCh", "captionEn", "captionRu", "category1", "category2", "category3", "createdAt", "descriptionCh", "descriptionEn", "descriptionRu", "id", "image_extension", "image_filesize", "image_height", "image_id", "image_width", "intervals", "isActive", "seller", "titleCh", "titleEn", "titleRu", "updatedAt") SELECT "author", "balance", "captionCh", "captionEn", "captionRu", "category1", "category2", "category3", "createdAt", "descriptionCh", "descriptionEn", "descriptionRu", "id", "image_extension", "image_filesize", "image_height", "image_id", "image_width", "intervals", "isActive", "seller", "titleCh", "titleEn", "titleRu", "updatedAt" FROM "Product";
DROP TABLE "Product";
ALTER TABLE "new_Product" RENAME TO "Product";
CREATE INDEX "Product_author_idx" ON "Product"("author");
CREATE INDEX "Product_seller_idx" ON "Product"("seller");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
