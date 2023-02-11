-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_OrderStatus" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "code" TEXT NOT NULL DEFAULT '',
    "color" TEXT NOT NULL DEFAULT '',
    "titleRu" TEXT NOT NULL DEFAULT '',
    "titleEn" TEXT NOT NULL DEFAULT '',
    "titleCh" TEXT NOT NULL DEFAULT '',
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME
);
INSERT INTO "new_OrderStatus" ("code", "color", "createdAt", "id", "titleCh", "titleEn", "titleRu", "updatedAt") SELECT "code", "color", "createdAt", "id", "titleCh", "titleEn", "titleRu", "updatedAt" FROM "OrderStatus";
DROP TABLE "OrderStatus";
ALTER TABLE "new_OrderStatus" RENAME TO "OrderStatus";
CREATE TABLE "new_Cart" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "products" TEXT NOT NULL DEFAULT '',
    "userId" TEXT NOT NULL DEFAULT '',
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME
);
INSERT INTO "new_Cart" ("createdAt", "id", "products", "updatedAt", "userId") SELECT "createdAt", "id", "products", "updatedAt", "userId" FROM "Cart";
DROP TABLE "Cart";
ALTER TABLE "new_Cart" RENAME TO "Cart";
CREATE UNIQUE INDEX "Cart_userId_key" ON "Cart"("userId");
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
INSERT INTO "new_Order" ("address", "confirmedAt", "createdAt", "id", "paidAt", "products", "seller", "status", "updatedAt", "user") SELECT "address", "confirmedAt", "createdAt", "id", "paidAt", "products", "seller", "status", "updatedAt", "user" FROM "Order";
DROP TABLE "Order";
ALTER TABLE "new_Order" RENAME TO "Order";
CREATE INDEX "Order_user_idx" ON "Order"("user");
CREATE INDEX "Order_seller_idx" ON "Order"("seller");
CREATE INDEX "Order_status_idx" ON "Order"("status");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
