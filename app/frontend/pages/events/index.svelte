<script lang="ts">
  import { page } from '@inertiajs/svelte';
  import { Button } from "$lib/components/ui/button";
  import * as Card from "$lib/components/ui/card";
  import * as Avatar from "$lib/components/ui/avatar";
  import { handleRegister } from '$lib/eventRegistrationUtils';

  export let events;
  export let current_user = $page.props.auth.user;

  let registeredEvents = events.reduce((acc, event) => {
    acc[event.id] = event.registered_by_current_user;
    return acc;
  }, {});

  function setRegisteredEvents(updatedEvents) {
    registeredEvents = updatedEvents;
  }

  async function onRegisterClick(event) {
    await handleRegister(event, registeredEvents, setRegisteredEvents);
  }
</script>

{#if current_user.role === 'candidate'}
  <h1 class="mx-auto my-24 text-5xl text-center">Temukan <span class="text-red-500">Acara Terbaik</span></h1>
{:else if current_user.role === 'employer'}
  <h1 class="mx-auto my-24 text-5xl text-center">Acara yang  <span class="text-red-500">Anda Selenggarakan</span></h1>
{/if}

<div class="grid grid-cols-1 gap-4">
  {#each events as event}
    <Card.Root class="w-full max-w-full overflow-hidden rounded-lg shadow-lg">
      <div class="w-full">
        <Card.Header class="flex p-0 pt-6 mt-4">
          <div class="flex px-4 space-x-6">
            <Avatar.Root class="w-24 h-24">
              <Avatar.Image src={event.employer.user.profile_picture} alt="Employer Profile Picture" class="object-cover" />
              <Avatar.Fallback></Avatar.Fallback>
            </Avatar.Root>
            <div class="self-center">
              <Card.Title class="text-xl font-bold">{event.name}</Card.Title>
              <Card.Description class="text-sm">{event.location} . <span class="text-sm">{event.status}</span></Card.Description>
            </div>
          </div>
        </Card.Header>
        <Card.Footer class="flex justify-end pb-4 border-gray-200">
          <Button href={`/events/${event.id}`} variant="outline" class="mr-2">Detail Lebih Lanjut
          </Button>

          {#if current_user.role === 'candidate'}
            <Button
              class={`self-center ${registeredEvents[event.id] ? 'bg-green-600 text-white' : ''}`}
              on:click={() => onRegisterClick(event)}
            >
              {registeredEvents[event.id] ? "Registered" : "Register"}
            </Button>
          {:else if current_user.role === 'employer'}
            <Button href={`/events/${event.id}/edit`}>Edit Acara</Button>
          {/if}
        </Card.Footer>
      </div>
    </Card.Root>
  {/each}
</div>
