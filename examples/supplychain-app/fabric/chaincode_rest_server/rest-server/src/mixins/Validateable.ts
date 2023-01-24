import { validate, ValidationError } from 'class-validator';

interface ErrorMessages {
  [key: string]: string[];
}

export class Validateable {
  async validate(): Promise<ErrorMessages> {
    const errors = await validate(this);
    return this.formatErrors(errors);
  }

  formatErrors(errors: ValidationError[]): ErrorMessages {
    return errors.reduce((obj, error) => {
      if (obj[error.property] === undefined) obj[error.property] = [];
      if (error.constraints !== undefined) {
        obj[error.property] = Object.values(error.constraints);
      }
      if (error.children.length > 0) {
        obj[error.property].push(this.formatErrors(error.children));
      }
      return obj;
    }, {});
  }
}
