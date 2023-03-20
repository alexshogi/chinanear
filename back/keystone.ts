// Welcome to Keystone!
//
// This file is what Keystone uses as the entry-point to your headless backend
//
// Keystone imports the default export of this file, expecting a Keystone configuration object
//   you can find out more at https://keystonejs.com/docs/apis/config

import { config } from '@keystone-6/core';

// to keep this file tidy, we define our schema in a different file
import { lists } from './schema';

// authentication is configured separately here too, but you might move this elsewhere
// when you write your list-level access control functions, as they typically rely on session data
import { withAuth, session } from './auth';

// import storage to save images there
import type { StorageConfig } from '@keystone-6/core/types'

export default withAuth(
  config({
    db: {
      provider: 'sqlite',
      useMigrations: true,
      url: 'file:./keystone.db',
    },
    lists,
    session,
    server: {
      cors: { origin: ['http://localhost:8080', 'http://localhost:80', 'http://localhost:8081', 'https://chinanear-back.vercel.app/', 'http://194.58.122.11:8080', 'http://192.168.1.10:8080'] },
      options: {
        // host: '0.0.0.0',
      },
    },
    storage: {
      server_storage: {
        kind: 'local',
        type: 'image',
        generateUrl: path => `http://localhost:3000/images${path}`,
        // generateUrl: path => `http://194.58.122.11:3000/images${path}`,
        serverRoute: {
          path: '/images',
        },
        storagePath: 'public/images',
      },
    },
  })
);
