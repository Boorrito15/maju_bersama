<script lang="ts">
  import { page } from '@inertiajs/svelte';
  import { Button } from "$lib/components/ui/button/index.js";
  import * as Card from "$lib/components/ui/card/index.js";
  import * as Avatar from "$lib/components/ui/avatar";

  export let job_applications;
  export let user_role = $page.props.auth.user.role;

  console.log(job_applications); // Debugging to check the data structure
</script>

{#if user_role === 'candidate'}
  <h1 class="mx-auto my-24 text-5xl text-center">Lamaran <span class="text-red-500">Pekerjaan Saya
  </span></h1>
{:else if user_role === 'employer'}
  <h1 class="mx-auto my-24 text-5xl text-center">Lamaran <span class="text-red-500">Pekerjaan yang Masuk </span></h1>
{/if}
<div class="grid grid-cols-1 gap-4">
  {#each job_applications as application}
    <Card.Root class="w-full max-w-full overflow-hidden rounded-lg shadow-lg">
      <div class="w-full">
        <Card.Header class="flex p-0 pt-6 mt-4">
          <div class="flex px-4 space-x-6">
            <Avatar.Root class="w-24 h-24">
              {#if user_role === 'candidate'}
                <Avatar.Image src={application.job.employer.user.profile_picture} alt="Employer Profile Picture" class="object-cover" />
              {:else if user_role === 'employer'}
                <Avatar.Image src={application.user.candidate.profile_picture} alt="Candidate Profile Picture" class="object-cover" />
              {/if}
              <Avatar.Fallback></Avatar.Fallback>
            </Avatar.Root>
            <div class="self-center space-y-2">
              {#if user_role === 'employer'}
                <Card.Title class="text-xl font-bold">{application.user.candidate.first_name} {application.user.candidate.last_name}</Card.Title>
              {/if}

              <Card.Description class="text-sm font-bold">{application.job.title}</Card.Description>
              <Card.Description class="text-sm">{application.job.location}</Card.Description>
            </div>
          </div>
        </Card.Header>
        <Card.Footer class="flex justify-end pb-4 border-gray-200">

          <Button href={`/jobs/${application.job.id}`} variant="outline" class="mr-2">Lihat Daftar Pekerjaan</Button>

          {#if user_role === 'employer'}
            <Button href={`/candidates/${application.user.candidate.id}`} class="mr-2">Lihat Kandidat</Button>
          {/if}
          {#if user_role === 'candidate'}
            <div class="self-center font-bold text-green-600">
              Terdaftar pada {new Date(application.created_at).toLocaleDateString()}
            </div>
          {/if}
        </Card.Footer>
      </div>
    </Card.Root>
  {/each}
</div>
