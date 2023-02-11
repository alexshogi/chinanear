/*
  Warnings:

  - You are about to drop the column `number` on the `Order` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_Order" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "products" TEXT,
    "user" TEXT,
    "seller" TEXT,
    "status" TEXT,
    "address" TEXT NOT NULL DEFAULT '',
    "comment" TEXT NOT NULL DEFAULT '',
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME,
    "confirmedAt" DATETIME,
    "paidAt" DATETIME,
    CONSTRAINT "Order_user_fkey" FOREIGN KEY ("user") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Order_seller_fkey" FOREIGN KEY ("seller") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "Order_status_fkey" FOREIGN KEY ("status") REFERENCES "OrderStatus" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_Order" ("address", "comment", "confirmedAt", "createdAt", "id", "paidAt", "products", "seller", "status", "updatedAt", "user") SELECT "address", "comment", "confirmedAt", "createdAt", "id", "paidAt", "products", "seller", "status", "updatedAt", "user" FROM "Order";
DROP TABLE "Order";
ALTER TABLE "new_Order" RENAME TO "Order";
CREATE INDEX "Order_user_idx" ON "Order"("user");
CREATE INDEX "Order_seller_idx" ON "Order"("seller");
CREATE INDEX "Order_status_idx" ON "Order"("status");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
