/*****************************************************************************
 * pce                                                                       *
 *****************************************************************************/

/*****************************************************************************
 * File name:   src/arch/macplus/scsi.h                                      *
 * Created:     2007-11-13 by Hampa Hug <hampa@hampa.ch>                     *
 * Copyright:   (C) 2007-2009 Hampa Hug <hampa@hampa.ch>                     *
 *****************************************************************************/

/*****************************************************************************
 * This program is free software. You can redistribute it and / or modify it *
 * under the terms of the GNU General Public License version 2 as  published *
 * by the Free Software Foundation.                                          *
 *                                                                           *
 * This program is distributed in the hope  that  it  will  be  useful,  but *
 * WITHOUT  ANY   WARRANTY,   without   even   the   implied   warranty   of *
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU  General *
 * Public License for more details.                                          *
 *****************************************************************************/


#ifndef PCE_MACPLUS_SCSI_H
#define PCE_MACPLUS_SCSI_H 1


typedef struct mac_scsi_s {
	unsigned      phase;

	unsigned char odr;
	unsigned char csd;
	unsigned char icr;
	unsigned char mr2;
	unsigned char tcr;
	unsigned char csb;
	unsigned char ser;
	unsigned char bsr;

	unsigned char status;
	unsigned char message;

	unsigned      cmd_i;
	unsigned      cmd_n;
	unsigned char cmd[16];

	unsigned long buf_i;
	unsigned long buf_n;
	unsigned long buf_max;
	unsigned char *buf;

	unsigned      sel_drv;

	unsigned      drive[8];

	void          (*cmd_start) (struct mac_scsi_s *scsi);
	void          (*cmd_finish) (struct mac_scsi_s *scsi);

	disks_t       *dsks;
} mac_scsi_t;


void mac_scsi_init (mac_scsi_t *scsi);
void mac_scsi_free (mac_scsi_t *scsi);

void mac_scsi_set_disks (mac_scsi_t *scsi, disks_t *dsks);
void mac_scsi_set_drive (mac_scsi_t *scsi, unsigned id, unsigned drive);

unsigned char mac_scsi_get_uint8 (void *ext, unsigned long addr);
unsigned short mac_scsi_get_uint16 (void *ext, unsigned long addr);

void mac_scsi_set_uint8 (void *ext, unsigned long addr, unsigned char val);
void mac_scsi_set_uint16 (void *ext, unsigned long addr, unsigned short val);

void mac_scsi_reset (mac_scsi_t *scsi);


#endif
