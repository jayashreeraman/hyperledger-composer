import { Component } from '@angular/core';
import { ActiveDrawer, DrawerService } from '../../common/drawer';

import { AdminService } from '../../services/admin.service';
import { ClientService } from '../../services/client.service';
import { SampleBusinessNetworkService } from '../../services/samplebusinessnetwork.service';
import { AlertService } from '../../basic-modals/alert.service';
import { ReplaceComponent } from '../../basic-modals/replace-confirm';

import { IdCard } from 'composer-common';
import { BusinessNetworkDefinition } from 'composer-common';
import { ErrorComponent } from '../../basic-modals/error';

const fabricComposerOwner = 'hyperledger';
const fabricComposerRepository = 'composer-sample-networks';

@Component({
    selector: 'import-identity',
    templateUrl: './import-identity.component.html',
    styleUrls: ['./import-identity.component.scss'.toString()]
})
export class ImportIdentityComponent {

    private importInProgress: boolean = false;

    private expandInput: boolean = false;
    private maxFileSize: number = 52428800;
    private supportedFileTypes: string[] = ['.card'];

    private identityCard: IdCard;

    constructor(public activeDrawer: ActiveDrawer,
                public drawerService: DrawerService,
                private alertService: AlertService) {

    }

    removeFile() {
        this.expandInput = false;
        this.identityCard = null;
    }

    private fileDetected() {
        this.expandInput = true;
    }

    private fileLeft() {
        this.expandInput = false;
    }

    private fileAccepted(file: File) {
        let fileReader = new FileReader();
        fileReader.onload = () => {
            let dataBuffer = Buffer.from(fileReader.result);

            this.readCard(dataBuffer);
        };

        fileReader.readAsArrayBuffer(file);
    }

    private readCard(cardData: Buffer) {
        IdCard.fromArchive(cardData).then((card) => {
            this.expandInput = true;
            this.identityCard = card;
        }).catch((reason) => {
            this.fileRejected(reason.message || 'Could not read ID card');
        });
    }

    private fileRejected(reason: string) {
        this.activeDrawer.dismiss(reason);
    }

    private import() {
        this.activeDrawer.close(this.identityCard);
    }
}
