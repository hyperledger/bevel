export class Product {
  productName: string;
  health: string;
  sold: boolean;
  recalled: boolean;
  misc: { [key: string]: any };
  custodian: string;
  trackingID: string;
  timestamp: number;
  containerID: string;
  particpants: string[];
}
