<script lang="ts">
  import { page } from '@inertiajs/svelte';
  import { Button } from "$lib/components/ui/button/index.js";
  import * as Card from "$lib/components/ui/card/index.js";
  import * as Avatar from "$lib/components/ui/avatar";

  export let event_registrations;
  export let user_role = $page.props.auth.user.role;

  console.log(event_registrations); // Debugging to check the data structure
</script>

{#if user_role === 'candidate'}
  <h1 class="mx-auto my-24 text-5xl text-center">Pendaftaran
    <span class="text-red-500">Acara Saya</span></h1>
{:else if user_role === 'employer'}
  <h1 class="mx-auto my-24 text-5xl text-center">Event <span class="text-red-500">attendees </span></h1>
{/if}

<div class="grid grid-cols-1 gap-4">
  {#each event_registrations as registration}
    <Card.Root class="w-full max-w-full overflow-hidden rounded-lg shadow-lg">
      <div class="w-full">
        <Card.Header class="flex p-0 pt-6 mt-4">
          <div class="flex px-4 space-x-6">
            <Avatar.Root class="w-24 h-24">
              {#if user_role === 'candidate'}
                <Avatar.Image src={registration.event.employer.user.profile_picture} alt="Employer Profile Picture" class="object-cover" />
              {:else if user_role === 'employer'}
                <Avatar.Image src={registration.user.candidate.profile_picture} alt="Candidate Profile Picture" class="object-cover" />
              {/if}
              <Avatar.Fallback></Avatar.Fallback>
            </Avatar.Root>
            <div class="self-center space-y-2">
              {#if user_role === 'employer'}
                <Card.Title class="text-xl font-bold">{registration.user.candidate.first_name} {registration.user.candidate.last_name}</Card.Title>
              {/if}
              <Card.Description class="text-sm font-bold">{registration.event.name}</Card.Description>
              <Card.Description class="text-sm">{registration.event.location}</Card.Description>
            </div>
          </div>
        </Card.Header>
        <Card.Footer class="flex justify-end pb-4 border-gray-200">
          <Button href={`/events/${registration.event.id}`} variant="outline" class="mr-2">Detail Lebih Lanjut </Button>

          {#if user_role === 'employer'}
            <Button href={`/candidates/${registration.user.candidate.id}`} class="mr-2">Lihat Peserta</Button>
          {:else if user_role === 'candidate'}
            <div class="self-center font-bold text-green-600">
              Terdaftar pada {new Date(registration.created_at).toLocaleDateString()}
            </div>
          {/if}
        </Card.Footer>
      </div>
    </Card.Root>
  {/each}
</div>
