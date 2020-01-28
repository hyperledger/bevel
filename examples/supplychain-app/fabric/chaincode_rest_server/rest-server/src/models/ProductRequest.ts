import { deserialize } from 'class-transformer';
import { IsDefined, IsNotEmpty, IsUUID } from 'class-validator';
import { Validateable } from 'mixins/Validateable';

export class ProductRequest extends Validateable {
  static fromJSON(json: string): ProductRequest {
    return deserialize(ProductRequest, json);
  }

  @IsNotEmpty()
  @IsDefined()
  productName: string;

  @IsNotEmpty()
  @IsDefined()
  health: string;

  @IsNotEmpty()
  @IsDefined()
  misc: { [key: string]: any };

  @IsNotEmpty()
  @IsDefined()
  @IsUUID()
  trackingID: string;

  @IsNotEmpty()
  @IsDefined()
  counterparties: string[];

  lastScannedAt: string;
}
