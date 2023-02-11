-- AlterTable
ALTER TABLE "Order" ADD COLUMN "number" INTEGER;

-- CreateIndex
CREATE INDEX "Order_number_idx" ON "Order"("number");
