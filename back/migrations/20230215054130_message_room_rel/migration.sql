-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_ChatMessage" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "content" TEXT NOT NULL DEFAULT '',
    "room" TEXT,
    "sender" TEXT,
    "date" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "system" BOOLEAN NOT NULL DEFAULT false,
    "saved" BOOLEAN NOT NULL DEFAULT false,
    "distributed" BOOLEAN NOT NULL DEFAULT true,
    "seen" BOOLEAN NOT NULL DEFAULT true,
    "deleted" BOOLEAN NOT NULL DEFAULT false,
    "disableActions" BOOLEAN NOT NULL DEFAULT true,
    "disableReactions" BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT "ChatMessage_room_fkey" FOREIGN KEY ("room") REFERENCES "ChatRoom" ("id") ON DELETE SET NULL ON UPDATE CASCADE,
    CONSTRAINT "ChatMessage_sender_fkey" FOREIGN KEY ("sender") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);
INSERT INTO "new_ChatMessage" ("content", "date", "deleted", "disableActions", "disableReactions", "distributed", "id", "saved", "seen", "sender", "system") SELECT "content", "date", "deleted", "disableActions", "disableReactions", "distributed", "id", "saved", "seen", "sender", "system" FROM "ChatMessage";
DROP TABLE "ChatMessage";
ALTER TABLE "new_ChatMessage" RENAME TO "ChatMessage";
CREATE INDEX "ChatMessage_room_idx" ON "ChatMessage"("room");
CREATE INDEX "ChatMessage_sender_idx" ON "ChatMessage"("sender");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;
