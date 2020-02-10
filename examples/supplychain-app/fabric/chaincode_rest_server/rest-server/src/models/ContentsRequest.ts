import { deserialize } from 'class-transformer';
import { IsDefined, IsNotEmpty, IsUUID } from 'class-validator';
import { Validateable } from 'mixins/Validateable';

export class ContentsRequest extends Validateable {
  static fromJSON(json: string): ContentsRequest {
    return deserialize(ContentsRequest, json);
  }

  @IsNotEmpty()
  @IsDefined()
  @IsUUID()
  contents: string;
}
