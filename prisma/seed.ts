import { prisma } from '../src/lib/prisma'
import { faker } from '@faker-js/faker'
import { Prisma } from '@prisma/client'
import dayjs from 'dayjs'

async function seed() {
  const eventId = '99713657-03a8-4c9f-831d-4cca180cb367'

  await prisma.event.deleteMany()

  await prisma.event.create({
    data: {
      id: eventId,
      title: 'Unite Summit',
      slug: 'unite-summit',
      details: 'Um evento p/ devs apaixonados por código!',	
      maximumAttendees: 120,
    }
  })

  const attendeesToInsert: Prisma.AttendeeUncheckedCreateInput[] = []

  for (let i = 0; i <= 212; i++) {
    attendeesToInsert.push({
      name: faker.person.fullName(),
      email: faker.internet.email().toLocaleLowerCase(),
      eventId,
      createdAt: faker.date.recent({ days: 30, refDate: dayjs().subtract(8, "days").toDate() }),
      checkIn: faker.helpers.arrayElement<Prisma.CheckInUncheckedCreateNestedOneWithoutAttendeeInput | undefined>([
        undefined,
        {
          create: {
            createdAt: faker.date.recent({ days: 7 })
          }
        }
      ])
    })
  }

  await Promise.all(attendeesToInsert.map(data => {
    return prisma.attendee.create({ data })
  }))
}

seed().then(() => {
  console.log('Seed complete');
  prisma.$disconnect();
})