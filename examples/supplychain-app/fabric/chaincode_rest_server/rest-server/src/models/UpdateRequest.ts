import { deserialize } from 'class-transformer';
import { IsDefined, IsNotEmpty, IsUUID } from 'class-validator';
import { Validateable } from 'mixins/Validateable';

export class UpdateRequest extends Validateable {
  static fromJSON(json: string): UpdateRequest {
    return deserialize(UpdateRequest, json);
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
  location: string;
}
