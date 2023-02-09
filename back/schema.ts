// Welcome to your schema
//   Schema driven development is Keystone's modus operandi
//
// This file is where we define the lists, fields and hooks for our data.
// If you want to learn more about how lists are configured, please read
// - https://keystonejs.com/docs/config/lists

import { list } from '@keystone-6/core';
import { allowAll } from '@keystone-6/core/access';

import {
  text,
  integer,
  relationship,
  password,
  timestamp,
  checkbox,
  image,
  select,
  json
} from '@keystone-6/core/fields';

// the document field is a more complicated field, so it has it's own package
import { document } from '@keystone-6/fields-document';
// if you want to make your own fields, see https://keystonejs.com/docs/guides/custom-fields

// when using Typescript, you can refine your types to a stricter subset by importing
// the generated types from '.keystone/types'
import type { Lists } from '.keystone/types';

export const lists: Lists = {
  User: list({
    // WARNING
    //   for this starter project, anyone can create, query, update and delete anything
    //   if you want to prevent random people on the internet from accessing your data,
    //   you can find out more at https://keystonejs.com/docs/guides/auth-and-access-control
    access: allowAll,
    fields: {
      name: text({ validation: { isRequired: true } }),
      email: text({
        validation: { isRequired: true },
        isIndexed: 'unique',
      }),
      password: password({ validation: { isRequired: true } }),
      surname: text(),
      companyName: text(),
      companyMarketNameRu: text(),
      companyMarketNameEn: text(),
      postcode: text(),
      country: text(),
      city: text(),
      street: text(),
      house: text(),
      building: text(),
      productsCreated: relationship({ ref: 'Product.author', many: true }),
      productsSelling: relationship({ ref: 'Product.seller', many: true }),
      createdAt: timestamp({ defaultValue: { kind: 'now' } }),
      updatedAt: timestamp({ defaultValue: { kind: 'now' } }),
    },
  }),

  Product: list({
    access: allowAll,
    fields: {
      title: text({ validation: { isRequired: true } }),
      caption: text(),
      description: document({ formatting: true, dividers: true, links: true, }),
      balance: integer({ validation: { min: 0 } }),
      category1: text(),
      category2: text(),
      category3: text(),
      intervals: json(),
      isActive: checkbox(),
      createdAt: timestamp({ defaultValue: { kind: 'now' } }),
      updatedAt: timestamp({ defaultValue: { kind: 'now' } }),
      image: image({ storage: 'server_storage' }),
      author: relationship({
        ref: 'User.productsCreated',
        ui: {
          displayMode: 'cards',
          cardFields: ['name', 'email'],
          inlineEdit: { fields: ['name', 'email'] },
          linkToItem: true,
          inlineConnect: true,
        },
        many: false,
      }),
      seller: relationship({
        ref: 'User.productsSelling',
        ui: {
          displayMode: 'cards',
          cardFields: ['name', 'email'],
          inlineEdit: { fields: ['name', 'email'] },
          linkToItem: true,
          inlineConnect: true,
        },
        many: false,
      }),
      tags: relationship({
        ref: 'Tag.products',
        many: true,
        ui: {
          displayMode: 'cards',
          cardFields: ['name'],
          inlineEdit: { fields: ['name'] },
          linkToItem: true,
          inlineConnect: true,
          inlineCreate: { fields: ['name'] },
        },
      }),
    },
  }),

  Tag: list({
    access: allowAll,
    ui: {
      isHidden: true,
    },
    fields: {
      name: text(),
      products: relationship({ ref: 'Product.tags', many: true }),
    },
  }),

  Category: list({
    access: allowAll,
    fields: {
      code: text(),
      titleRu: text(),
      titleEn: text(),
      titleCh: text(),
      children: relationship({ ref: 'Category', many: true }),
      isActive: checkbox(),
      createdAt: timestamp({ defaultValue: { kind: 'now' } }),
      updatedAt: timestamp({ defaultValue: { kind: 'now' } }),
    },
  }),

  Cart: list({
    access: allowAll,
    fields: {
      products: text(),
      userId: text({
        validation: { isRequired: true },
        isIndexed: 'unique',
      }),
      createdAt: timestamp({ defaultValue: { kind: 'now' } }),
      updatedAt: timestamp(),
    }
  }),

  OrderStatus: list({
    access: allowAll,
    fields: {
      code: text(),
      color: text(),
      titleRu: text(),
      titleEn: text(),
      titleCh: text(),
      createdAt: timestamp({ defaultValue: { kind: 'now' } }),
      updatedAt: timestamp(),
    }
  }),

  Order: list({
    access: allowAll,
    fields: {
      products: json(),
      user: relationship({ ref: 'User' }),
      seller: relationship({ ref: 'User' }),
      status: relationship({ ref: 'OrderStatus' }),
      address: text(),
      comment: text(),
      createdAt: timestamp({ defaultValue: { kind: 'now' } }),
      updatedAt: timestamp(),
      confirmedAt: timestamp(),
      paidAt: timestamp(),
    }
  })
};
