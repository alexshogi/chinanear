-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_User" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "name" TEXT NOT NULL DEFAULT '',
    "email" TEXT NOT NULL DEFAULT '',
    "password" TEXT NOT NULL,
    "surname" TEXT NOT NULL DEFAULT '',
    "companyName" TEXT NOT NULL DEFAULT '',
    "companyMarketNameRu" TEXT NOT NULL DEFAULT '',
    "companyMarketNameEn" TEXT NOT NULL DEFAULT '',
    "postcode" TEXT NOT NULL DEFAULT '',
    "country" TEXT NOT NULL DEFAULT '',
    "city" TEXT NOT NULL DEFAULT '',
    "street" TEXT NOT NULL DEFAULT '',
    "house" TEXT NOT NULL DEFAULT '',
    "building" TEXT NOT NULL DEFAULT '',
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP
);
INSERT INTO "new_User" ("createdAt", "email", "id", "name", "password", "updatedAt") SELECT "createdAt", "email", "id", "name", "password", "updatedAt" FROM "User";
DROP TABLE "User";
ALTER TABLE "new_User" RENAME TO "User";
CREATE UNIQUE INDEX "User_email_key" ON "User"("email");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
