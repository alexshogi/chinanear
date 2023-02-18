-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_ChatRoom" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "roomName" TEXT NOT NULL DEFAULT '',
    "buyer_seller" TEXT NOT NULL DEFAULT ''
);
INSERT INTO "new_ChatRoom" ("id", "roomName") SELECT "id", "roomName" FROM "ChatRoom";
DROP TABLE "ChatRoom";
ALTER TABLE "new_ChatRoom" RENAME TO "ChatRoom";
CREATE UNIQUE INDEX "ChatRoom_buyer_seller_key" ON "ChatRoom"("buyer_seller");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
