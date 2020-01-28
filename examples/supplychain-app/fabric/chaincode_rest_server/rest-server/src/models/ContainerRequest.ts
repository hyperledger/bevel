import { deserialize } from 'class-transformer';
import { IsDefined, IsNotEmpty, IsUUID } from 'class-validator';
import { Validateable } from 'mixins/Validateable';

export class ContainerRequest extends Validateable {
  static fromJSON(json: string): ContainerRequest {
    return deserialize(ContainerRequest, json);
  }

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
