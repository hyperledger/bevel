import * as Router from 'koa-router';
import { ContainerController, GeneralController, ProductController } from './controller';

const router = new Router({
  prefix: '/api/v1',
});

// General Routes
router.get('/:trackingID/scan', GeneralController.scan);
router.get('/:trackingID/history', GeneralController.getHistory);
router.get('/node-organization', GeneralController.getOrganization);
router.get('/node-organizationUnit', GeneralController.getOrganizationUnit);

// Product Routes
router.post('/product/', ProductController.createProduct);
router.get('/product/containerless', ProductController.getContainerlessProducts);
router.get('/product/:trackingID*', ProductController.getProducts);
router.put('/product/:trackingID', ProductController.updateProduct);
router.put('/product/:trackingID/custodian', ProductController.claimProduct);

// Container Routes
router.post('/container/', ContainerController.createContainer);
router.get('/container/:trackingID*', ContainerController.getContainer);
router.put('/container/:trackingID', ContainerController.updateContainer);
router.put('/container/:trackingID/custodian', ContainerController.claimContainer);
router.put('/container/:trackingID/package', ContainerController.package);
router.put('/container/:trackingID/unpackage', ContainerController.unpackage);

export { router };
