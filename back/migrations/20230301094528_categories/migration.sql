-- CreateTable
CREATE TABLE "SubCategory" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "code" TEXT NOT NULL DEFAULT '',
    "titleRu" TEXT NOT NULL DEFAULT '',
    "titleEn" TEXT NOT NULL DEFAULT '',
    "titleCh" TEXT NOT NULL DEFAULT '',
    "isActive" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "SubSubCategory" (
    "id" TEXT NOT NULL PRIMARY KEY,
    "code" TEXT NOT NULL DEFAULT '',
    "titleRu" TEXT NOT NULL DEFAULT '',
    "titleEn" TEXT NOT NULL DEFAULT '',
    "titleCh" TEXT NOT NULL DEFAULT '',
    "isActive" BOOLEAN NOT NULL DEFAULT false,
    "createdAt" DATETIME DEFAULT CURRENT_TIMESTAMP,
    "updatedAt" DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "_SubCategory_parent" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_SubCategory_parent_A_fkey" FOREIGN KEY ("A") REFERENCES "Category" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_SubCategory_parent_B_fkey" FOREIGN KEY ("B") REFERENCES "SubCategory" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_SubCategory_children" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_SubCategory_children_A_fkey" FOREIGN KEY ("A") REFERENCES "SubCategory" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_SubCategory_children_B_fkey" FOREIGN KEY ("B") REFERENCES "SubSubCategory" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- CreateTable
CREATE TABLE "_SubSubCategory_parent" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_SubSubCategory_parent_A_fkey" FOREIGN KEY ("A") REFERENCES "SubCategory" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_SubSubCategory_parent_B_fkey" FOREIGN KEY ("B") REFERENCES "SubSubCategory" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);

-- RedefineTables
PRAGMA foreign_keys=OFF;
CREATE TABLE "new__Category_children" (
    "A" TEXT NOT NULL,
    "B" TEXT NOT NULL,
    CONSTRAINT "_Category_children_A_fkey" FOREIGN KEY ("A") REFERENCES "Category" ("id") ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT "_Category_children_B_fkey" FOREIGN KEY ("B") REFERENCES "SubCategory" ("id") ON DELETE CASCADE ON UPDATE CASCADE
);
INSERT INTO "new__Category_children" ("A", "B") SELECT "A", "B" FROM "_Category_children";
DROP TABLE "_Category_children";
ALTER TABLE "new__Category_children" RENAME TO "_Category_children";
CREATE UNIQUE INDEX "_Category_children_AB_unique" ON "_Category_children"("A", "B");
CREATE INDEX "_Category_children_B_index" ON "_Category_children"("B");
PRAGMA foreign_key_check;
PRAGMA foreign_keys=ON;

-- CreateIndex
CREATE UNIQUE INDEX "_SubCategory_parent_AB_unique" ON "_SubCategory_parent"("A", "B");

-- CreateIndex
CREATE INDEX "_SubCategory_parent_B_index" ON "_SubCategory_parent"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_SubCategory_children_AB_unique" ON "_SubCategory_children"("A", "B");

-- CreateIndex
CREATE INDEX "_SubCategory_children_B_index" ON "_SubCategory_children"("B");

-- CreateIndex
CREATE UNIQUE INDEX "_SubSubCategory_parent_AB_unique" ON "_SubSubCategory_parent"("A", "B");

-- CreateIndex
CREATE INDEX "_SubSubCategory_parent_B_index" ON "_SubSubCategory_parent"("B");
