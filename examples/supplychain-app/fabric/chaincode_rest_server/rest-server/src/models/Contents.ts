import { deserialize } from 'class-transformer';
import { IsDefined, IsNotEmpty } from 'class-validator';
import { Validateable } from 'mixins/Validateable';

export class Contents extends Validateable {
  static fromJSON(json: string): Contents {
    return deserialize(Contents, json);
  }

  @IsNotEmpty()
  @IsDefined()
  contents: string;
}
