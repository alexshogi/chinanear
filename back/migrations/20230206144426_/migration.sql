/*
  Warnings:

  - You are about to drop the `_Cart_products` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the column `user` on the `Cart` table. All the data in the column will be lost.

*/
-- DropIndex
DROP INDEX "_Cart_products_B_index";

-- DropIndex
DROP INDEX "_Cart_products_AB_unique";

-- DropTable
PRAGMA foreign_keys=off;
DROP TABLE "_Cart_products";
PRAGMA foreign_keys=on;

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Cart" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "products" TEXT NOT NULL DEFAULT '',
    "userId" TEXT NOT NULL DEFAULT '',
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "new_Cart" ("createdAt", "id", "updatedAt") SELECT "createdAt", "id", "updatedAt" FROM "Cart";
DROP TABLE "Cart";
ALTER TABLE "new_Cart" RENAME TO "Cart";
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
