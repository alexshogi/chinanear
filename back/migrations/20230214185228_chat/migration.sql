-- CreateTable
CREATE TABLE "ChatRoom" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "roomName" TEXT NOT NULL DEFAULT ''
);

-- CreateTable
CREATE TABLE "ChatMessage" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "content" TEXT NOT NULL DEFAULT '',
    "sender" TEXT,
    "date" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "system" BOOLEAN NOT NULL DEFAULT false,
    "saved" BOOLEAN NOT NULL DEFAULT false,
    "distributed" BOOLEAN NOT NULL DEFAULT true,
    "seen" BOOLEAN NOT NULL DEFAULT true,
    "deleted" BOOLEAN NOT NULL DEFAULT false,
    "disableActions" BOOLEAN NOT NULL DEFAULT true,
    "disableReactions" BOOLEAN NOT NULL DEFAULT true,
    CONSTRAINT "ChatMessage_sender_fkey" FOREIGN KEY ("sender") REFERENCES "User" ("id") ON DELETE SET NULL ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_ChatRoom_users" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_ChatRoom_users_A_fkey" FOREIGN KEY ("A") REFERENCES "ChatRoom" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_ChatRoom_users_B_fkey" FOREIGN KEY ("B") REFERENCES "User" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateIndex
CREATE INDEX "ChatMessage_sender_idx" ON "ChatMessage"("sender");

-- CreateIndex
CREATE UNIQUE INDEX "_ChatRoom_users_AB_unique" ON "_ChatRoom_users"("A", "B");

-- CreateIndex
CREATE INDEX "_ChatRoom_users_B_index" ON "_ChatRoom_users"("B");
