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
  decimal,
  relationship,
  password,
  timestamp,
  checkbox,
  image,
  json
} from '@keystone-6/core/fields';

// when using Typescript, you can refine your types to a stricter subset by importing
// the generated types from '.keystone/types'
import type { Lists } from '.keystone/types';
import { BaseAccessArgs, AccessOperation } from '@keystone-6/core/dist/declarations/src/types/config/access-control';
import { MaybePromise } from '@keystone-6/core/types';

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
      role: text({ defaultValue: 'user' }),
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

  Image: list({
    access: allowAll,
    fields: {
      name: text({ validation: { isRequired: true } }),
      altText: text(),
      image: image({ storage: 'server_storage' }),
    },
  }),

  Product: list({
    access: allowAll,
    fields: {
      titleRu: text(),
      titleEn: text(),
      titleCh: text(),
      captionRu: text(),
      captionEn: text(),
      captionCh: text(),
      descriptionRu: text(),
      descriptionEn: text(),
      descriptionCh: text(),
      balance: integer({ validation: { min: 0 } }),
      category: relationship({ ref: 'Category' }),
      subCategory: relationship({ ref: 'SubCategory' }),
      subSubCategory: relationship({ ref: 'SubSubCategory' }),
      intervals: text(),
      isActive: checkbox(),
      createdAt: timestamp({ defaultValue: { kind: 'now' } }),
      updatedAt: timestamp({ defaultValue: { kind: 'now' } }),
      image: relationship({ ref: 'Image' }),
      images: relationship({ ref: 'Image', many: true }),
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
    ui: {
      labelField: 'titleRu',
    },
    fields: {
      code: text(),
      titleRu: text(),
      titleEn: text(),
      titleCh: text(),
      children: relationship({ ref: 'SubCategory', many: true }),
      isActive: checkbox(),
      createdAt: timestamp({ defaultValue: { kind: 'now' } }),
      updatedAt: timestamp({ defaultValue: { kind: 'now' } }),
    },
  }),

  SubCategory: list({
    access: allowAll,
    ui: {
      labelField: 'titleRu',
    },
    fields: {
      code: text(),
      titleRu: text(),
      titleEn: text(),
      titleCh: text(),
      parent: relationship({ ref: 'Category' }),
      children: relationship({ ref: 'SubSubCategory', many: true }),
      isActive: checkbox(),
      createdAt: timestamp({ defaultValue: { kind: 'now' } }),
      updatedAt: timestamp({ defaultValue: { kind: 'now' } }),
    },
  }),

  SubSubCategory: list({
    access: allowAll,
    ui: {
      labelField: 'titleRu',
    },
    fields: {
      code: text(),
      titleRu: text(),
      titleEn: text(),
      titleCh: text(),
      parent: relationship({ ref: 'SubCategory' }),
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
    ui: {
      searchFields: ['code', 'titleEn'],
      labelField: 'code',
    },
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
  }),

  ChatRoom: list({
    access: allowAll,
    fields: {
      roomName: text(),
      users: relationship({ ref: 'User', many: true }),
      buyer_seller: text({
        validation: { isRequired: true },
        isIndexed: 'unique',
      }),
    },
  }),

  ChatMessage: list({
    access: allowAll,
    fields: {
      content: text(),
      room: relationship({ ref: 'ChatRoom' }),
      sender: relationship({ ref: 'User' }),
      date: timestamp({ defaultValue: { kind: 'now' } }),
      system: checkbox({ defaultValue: false }),
      saved: checkbox({ defaultValue: false }),
      distributed: checkbox({ defaultValue: true }),
      seen: checkbox({ defaultValue: true }),
      deleted: checkbox({ defaultValue: false }),
      disableActions: checkbox({ defaultValue: true }),
      disableReactions: checkbox({ defaultValue: true }),
    }
  }),

  CurrencyRate: list({
    access: allowAll,
    description: 'Курс валюты по отношению к 1 USD. десятичную часть указывать через точку',
    fields: {
      code: text(),
      value: text(),
    }
  })
};
